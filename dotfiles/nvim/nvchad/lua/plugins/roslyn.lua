-- ~/.config/nvim/lua/plugins/roslyn.lua
return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },
  opts = function()
    return {
      config = {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_provide_regex_completions = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
        },
      },
    }
  end,
}

-- return {
--   {
--     "seblyng/roslyn.nvim",
--     ft = { "cs", "razor", "cshtml" },
--
--     opts = {
--       filewatching = "roslyn", -- rất quan trọng cho solution lớn
--       broad_search = true, -- cần cho MAUI
--       lock_target = true, -- tránh attach nhầm solution
--       silent = false,
--     },
--
--     config = function(_, opts)
--       -- setup plugin
--       require("roslyn").setup(opts)
--
--       -- setup LSP server settings
--       require "lsp.roslyn"
--     end,
--   },
-- }
