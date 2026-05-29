return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = { PATH = "prepend" },
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
			{
				"Hoffs/omnisharp-extended-lsp.nvim",
				lazy = true,
				ft = { "cs", "vb" },
			},
		},
		config = function()
			---@param names string[]
			---@return string[]
			local function dedupe(names)
				local seen = {}
				local out = {}
				for _, n in ipairs(names) do
					if not seen[n] then
						seen[n] = true
						out[#out + 1] = n
					end
				end
				return out
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("<leader>cd", vim.lsp.buf.hover, "[C]ode [D]ocumentation", { "n", "x" })
					map("gr", function()
						Snacks.picker.lsp_references()
					end, "[G]oto [R]eferences")
					map("gI", function()
						Snacks.picker.lsp_implementations()
					end, "[G]oto [I]mplementation")
					map("gd", function()
						Snacks.picker.lsp_definitions()
					end, "[G]oto [D]efinition")
					map("gD", function()
						Snacks.picker.lsp_declarations()
					end, "[G]oto [D]eclaration")
					map("<leader>ds", function()
						Snacks.picker.lsp_symbols()
					end, "Open [D]ocument [S]ymbols")
					map("<leader>ws", function()
						Snacks.picker.lsp_workspace_symbols()
					end, "Open [W]orkspace [S]ymbols")
					map("gt", function()
						Snacks.picker.lsp_type_definitions()
					end, "[G]oto [T]ype Definition")

					---@param client vim.lsp.Client
					local function client_supports_method(client, method, bufnr)
						return client:supports_method(method, bufnr)
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			--- Prefer Mason shim when present; otherwise `nil` from Nix (`pkgs.nil`) / PATH via `exepath`.
			local nil_cmd = (function()
				local candidates = {
					vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "mason", "bin", "nil"),
					vim.fn.exepath("nil"),
				}
				for _, p in ipairs(candidates) do
					if p ~= "" and vim.fn.executable(p) == 1 then
						return { p }
					end
				end
				return nil
			end)()

			--- Servers with explicit `vim.lsp.config` (overrides / capabilities).
			local servers = {
				rust_analyzer = {},
				intelephense = {},
				nil_ls = nil_cmd and { cmd = nil_cmd } or {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				omnisharp = {
					handlers = {
						["textDocument/definition"] = function(...)
							require("omnisharp_extended").definition_handler(...)
						end,
						["textDocument/typeDefinition"] = function(...)
							require("omnisharp_extended").type_definition_handler(...)
						end,
						["textDocument/references"] = function(...)
							require("omnisharp_extended").references_handler(...)
						end,
						["textDocument/implementation"] = function(...)
							require("omnisharp_extended").implementation_handler(...)
						end,
					},
				},
			}

			for name, sconfig in pairs(servers) do
				sconfig.capabilities = vim.tbl_deep_extend("force", {}, capabilities, sconfig.capabilities or {})
				vim.lsp.config(name, sconfig)
			end

			--- Mason package names map to these nvim-lspconfig / `:h lsp` client names.
			--- Enabled with defaults from nvim-lspconfig (no extra `vim.lsp.config` needed).
			local mason_lsp_names = {
				"ts_ls",
				"html",
				"cssls",
				"jsonls",
				"eslint",
				"tailwindcss",
				"emmet_language_server",
				"svelte",
				"volar",
				"angularls",
				"graphql",
				"marksman",
				"yamlls",
				"bashls",
				"dockerls",
				"docker_compose_language_service",
				"pyright",
				"ruff",
				--- prisma-language-server (nvim-lspconfig client name is `prismals`, not `prisma`)
				"prismals",
				"nil_ls",
			}

			local to_enable = vim.list_extend(vim.tbl_keys(servers), mason_lsp_names)
			vim.lsp.enable(dedupe(to_enable))

			local ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
				"typescript-language-server",
				"html-lsp",
				"css-lsp",
				"json-lsp",
				"eslint-lsp",
				"tailwindcss-language-server",
				"emmet-ls",
				"svelte-language-server",
				"vue-language-server",
				"angular-language-server",
				"graphql-language-service-cli",
				"marksman",
				"yaml-language-server",
				"bash-language-server",
				"dockerls",
				"docker-compose-language-service",
				"omnisharp",
				"netcoredbg",
				"csharpier",
				"pyright",
				"ruff",
				"ruff-lsp",
				"black",
				"isort",
				"debugpy",
				"prisma-language-server",
				"prettier",
				"stylua",
				"beautysh",
				"yamlfmt",
				"mdformat",
				"eslint_d",
				"stylelint",
				"markdownlint",
				"shellcheck",
				"hadolint",
				"yamllint",
				"js-debug-adapter",
				"dart-debug-adapter",
				"actionlint",
				"jq",
				"markdown-toc",
				-- `nil` LSP: Mason builds from source and needs `cargo` — install via Nix (`pkgs.nil`) instead.
				"nixfmt",
				"alejandra",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
			})
		end,
	},
}
