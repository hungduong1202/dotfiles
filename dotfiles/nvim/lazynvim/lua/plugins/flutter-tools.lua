return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    ft = "dart",
    config = function()
      -- alternatively you can override the default configs
      require("flutter-tools").setup({})

      local function create_feature()
        vim.ui.input({ prompt = "Feature name: " }, function(input)
          if not input or input == "" then
            vim.notify("No feature name provided!", vim.log.levels.WARN)
            return
          end

          local feature = string.lower(input)
          local feature_cap = feature:gsub("^%l", string.upper)
          local base_path = "lib/features/" .. feature

          local dirs = {
            base_path .. "/data/datasources",
            base_path .. "/data/models",
            base_path .. "/data/repositories",
            base_path .. "/domain/entities",
            base_path .. "/domain/repositories",
            base_path .. "/domain/usecases",
            base_path .. "/presentation/widgets",
          }

          for _, dir in ipairs(dirs) do
            vim.fn.mkdir(dir, "p")
          end

          -- routes.dart
          local routes_path = base_path .. "/routes.dart"
          local routes_content = string.format(
            [[
import 'package:auto_route/auto_route.dart';
import 'presentation/%s_page.dart';

const %sRoutes = AutoRoute(
  path: '/%s',
  page: %sPage,
);
]],
            feature,
            feature,
            feature,
            feature_cap
          )
          vim.fn.writefile(vim.split(routes_content, "\n"), routes_path)

          -- page.dart
          local page_path = base_path .. "/presentation/" .. feature .. "_page.dart"
          local page_content = string.format(
            [[
import 'package:flutter/material.dart';

class %sPage extends StatelessWidget {
  const %sPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("%s Page")),
      body: const Center(child: Text("%s Feature")),
    );
  }
}
]],
            feature_cap,
            feature_cap,
            feature_cap,
            feature
          )
          vim.fn.writefile(vim.split(page_content, "\n"), page_path)

          vim.notify("✅ Feature created: " .. feature, vim.log.levels.INFO)
        end)
      end

      -- Async build runner (chạy 1 lần)
      vim.api.nvim_create_user_command("FlutterBuild", function()
        vim.fn.jobstart({ "flutter", "pub", "run", "build_runner", "build", "--delete-conflicting-outputs" }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data then
              for _, line in ipairs(data) do
                if line ~= "" then
                  vim.notify(line, vim.log.levels.INFO)
                end
              end
            end
          end,
          on_stderr = function(_, data)
            if data then
              for _, line in ipairs(data) do
                if line ~= "" then
                  vim.notify(line, vim.log.levels.ERROR)
                end
              end
            end
          end,
        })
      end, {})

      -- Async build runner watch (background)
      vim.api.nvim_create_user_command("FlutterBuildWatch", function()
        vim.fn.jobstart(
          { "flutter", "pub", "run", "build_runner", "watch", "--delete-conflicting-outputs" },
          { detach = true } -- chạy nền, không block neovim
        )
        vim.notify("🚀 build_runner watch started...", vim.log.levels.INFO)
      end, {})

      -- Gắn keymap menu
      vim.keymap.set("n", "<leader>fp", function()
        local commands = {
          { label = "Run", cmd = "FlutterRun" },
          { label = "Run dev", cmd = "FlutterRun --flavor dev" },
          { label = "Hot Reload", cmd = "FlutterReload" },
          { label = "Hot Restart", cmd = "FlutterRestart" },
          { label = "Quit", cmd = "FlutterQuit" },
          { label = "Devices", cmd = "FlutterDevices" },
          { label = "Emulators", cmd = "FlutterEmulators" },
          { label = "Detach", cmd = "FlutterDetach" },
          { label = "Outline Toggle", cmd = "FlutterOutlineToggle" },
          { label = "Clear Log", cmd = "FlutterLogClear" },
          { label = "Log Toggle", cmd = "FlutterLogToggle" },
          { label = "Build Runner", cmd = "FlutterBuild" },
          { label = "Build Runner (watch)", cmd = "FlutterBuildWatch" },
          { label = "Create Feature", cmd = create_feature }, -- 🆕 thêm vào menu
        }

        vim.ui.select(commands, {
          prompt = "Flutter Commands",
          format_item = function(item)
            return item.label
          end,
        }, function(choice)
          if choice then
            if type(choice.cmd) == "function" then
              choice.cmd()
            elseif type(choice.cmd) == "string" then
              vim.cmd(choice.cmd)
            else
              vim.notify("Invalid command type for: " .. choice.label, vim.log.levels.ERROR)
            end
          end
        end)
      end, { desc = "Flutter Command Picker (Float)" })
    end,
  },
}
