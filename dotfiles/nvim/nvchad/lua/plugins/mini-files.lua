return {
  "nvim-mini/mini.files",
  version = "*",
  event = "VeryLazy",
  config = function()
    local ok, MiniFiles = pcall(require, "mini.files")
    if not ok then
      return
    end

    MiniFiles.setup()

    vim.keymap.set("n", "<leader>E", MiniFiles.open, { desc = "Open MiniFiles" })

    local nsMiniFiles = vim.api.nvim_create_namespace "MiniFilesGit"
    local autocmd = vim.api.nvim_create_autocmd
    local uv = vim.uv or vim.loop

    -- =========================
    -- Cache
    -- =========================
    local gitStatusCache = {}
    local cacheTimeout = 2 -- seconds

    local function isSymlink(path)
      local stat = uv.fs_lstat(path)
      return stat and stat.type == "link"
    end

    -- =========================
    -- Icon & Highlight mapping
    -- =========================
    local function mapSymbols(status, is_symlink)
      local statusMap = {
        [" M"] = { symbol = "•", hl = "MiniDiffSignChange" },
        ["M "] = { symbol = "✹", hl = "MiniDiffSignChange" },
        ["MM"] = { symbol = "≠", hl = "MiniDiffSignChange" },
        ["A "] = { symbol = "+", hl = "MiniDiffSignAdd" },
        ["AA"] = { symbol = "≈", hl = "MiniDiffSignAdd" },
        ["D "] = { symbol = "-", hl = "MiniDiffSignDelete" },
        ["AM"] = { symbol = "⊕", hl = "MiniDiffSignChange" },
        ["AD"] = { symbol = "-•", hl = "MiniDiffSignChange" },
        ["R "] = { symbol = "→", hl = "MiniDiffSignChange" },
        ["U "] = { symbol = "‖", hl = "MiniDiffSignChange" },
        ["UU"] = { symbol = "⇄", hl = "MiniDiffSignAdd" },
        ["UA"] = { symbol = "⊕", hl = "MiniDiffSignAdd" },
        ["??"] = { symbol = "?", hl = "MiniDiffSignDelete" },
        ["!!"] = { symbol = "!", hl = "MiniDiffSignChange" },
      }

      local item = statusMap[status] or { symbol = "?", hl = "NonText" }
      local symbol = (is_symlink and "↩" or "") .. item.symbol
      local hl = is_symlink and "MiniDiffSignDelete" or item.hl

      return symbol, hl
    end

    -- =========================
    -- Git status fetch
    -- =========================
    local function fetchGitStatus(cwd, callback)
      vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = cwd }, function(res)
        if res.code == 0 then
          callback(res.stdout)
        end
      end)
    end

    -- =========================
    -- Parse git status
    -- =========================
    local function parseGitStatus(content)
      local map = {}

      for line in content:gmatch "[^\r\n]+" do
        local status, path = line:match "^(..)%s+(.*)"
        if status and path then
          -- handle rename: old -> new
          path = path:match "->%s*(.*)" or path

          local parts = {}
          for p in path:gmatch "[^/]+" do
            table.insert(parts, p)
          end

          local key = ""
          for i, part in ipairs(parts) do
            key = (i == 1) and part or (key .. "/" .. part)
            map[key] = map[key] or status
          end
        end
      end

      return map
    end

    -- =========================
    -- Update MiniFiles UI
    -- =========================
    local function updateMiniWithGit(bufnr, statusMap)
      vim.schedule(function()
        vim.api.nvim_buf_clear_namespace(bufnr, nsMiniFiles, 0, -1)

        local cwd = vim.fs.root(bufnr, ".git")
        if not cwd then
          return
        end

        cwd = vim.fs.normalize(vim.pesc(cwd))
        local lines = vim.api.nvim_buf_line_count(bufnr)

        for i = 1, lines do
          local entry = MiniFiles.get_fs_entry(bufnr, i)
          if not entry then
            break
          end

          local rel = entry.path:gsub("^" .. cwd .. "/", "")
          local status = statusMap[rel]

          if status then
            local symbol, hl = mapSymbols(status, isSymlink(entry.path))

            vim.api.nvim_buf_set_extmark(bufnr, nsMiniFiles, i - 1, 0, {
              sign_text = symbol,
              sign_hl_group = hl,
              priority = 2,
            })

            local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
            local col = #line - #entry.name

            if col >= 0 then
              vim.api.nvim_buf_set_extmark(bufnr, nsMiniFiles, i - 1, col, {
                end_col = col + #entry.name,
                hl_group = hl,
              })
            end
          end
        end
      end)
    end

    -- =========================
    -- Public update
    -- =========================
    local function updateGitStatus(bufnr)
      local cwd = vim.fs.root(bufnr, ".git")
      if not cwd then
        return
      end

      local now = os.time()
      local cached = gitStatusCache[cwd]

      if cached and (now - cached.time < cacheTimeout) then
        updateMiniWithGit(bufnr, cached.map)
      else
        fetchGitStatus(cwd, function(content)
          local map = parseGitStatus(content)
          gitStatusCache[cwd] = { time = now, map = map }
          updateMiniWithGit(bufnr, map)
        end)
      end
    end

    -- =========================
    -- Autocmds
    -- =========================
    local function augroup(name)
      return vim.api.nvim_create_augroup("MiniFilesGit_" .. name, { clear = true })
    end

    autocmd("User", {
      group = augroup "open",
      pattern = "MiniFilesExplorerOpen",
      callback = function()
        updateGitStatus(vim.api.nvim_get_current_buf())
      end,
    })

    autocmd("User", {
      group = augroup "update",
      pattern = "MiniFilesBufferUpdate",
      callback = function(args)
        local bufnr = args.data.buf_id
        local cwd = vim.fs.root(bufnr, ".git")
        if cwd and gitStatusCache[cwd] then
          updateMiniWithGit(bufnr, gitStatusCache[cwd].map)
        end
      end,
    })

    autocmd("User", {
      group = augroup "close",
      pattern = "MiniFilesExplorerClose",
      callback = function()
        gitStatusCache = {}
      end,
    })
  end,
}
