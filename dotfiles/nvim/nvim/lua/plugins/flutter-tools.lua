return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        ui = {
          border = "rounded",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        debugger = {
          enabled = true,
        },
      })

      -- =========================
      -- Utils
      -- =========================
      local function notify_batch(data, level)
        local msg = table.concat(vim.tbl_filter(function(l)
          return l and l ~= ""
        end, data), "\n")

        if msg ~= "" then
          vim.notify(msg, level)
        end
      end

      -- =========================
      -- Create Feature (Clean Arch)
      -- =========================
      local function create_feature()
        vim.ui.input({ prompt = "Feature name: " }, function(input)
          if not input or input == "" then
            vim.notify("No feature name provided!", vim.log.levels.WARN)
            return
          end

          local feature = string.lower(input)
          local feature_cap = feature:gsub("^%l", string.upper)
          local cwd = vim.fn.getcwd()
          local base_path = cwd .. "/lib/features/" .. feature

          if vim.fn.isdirectory(base_path) == 1 then
            vim.notify("Feature already exists!", vim.log.levels.WARN)
            return
          end

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

          -- auto mở file
          vim.cmd("edit " .. page_path)
        end)
      end

      -- =========================
      -- Commands
      -- =========================
      vim.api.nvim_create_user_command("FlutterBuild", function()
        vim.fn.jobstart({
          "flutter",
          "pub",
          "run",
          "build_runner",
          "build",
          "--delete-conflicting-outputs",
        }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data then notify_batch(data, vim.log.levels.INFO) end
          end,
          on_stderr = function(_, data)
            if data then notify_batch(data, vim.log.levels.ERROR) end
          end,
        })
      end, {})

      vim.api.nvim_create_user_command("FlutterBuildWatch", function()
        vim.fn.jobstart({
          "flutter",
          "pub",
          "run",
          "build_runner",
          "watch",
          "--delete-conflicting-outputs",
        }, {
          detach = true,
        })
        vim.notify("🚀 build_runner watch started...", vim.log.levels.INFO)
      end, {})

      -- =========================
      -- Keymap (buffer-local)
      -- =========================
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dart",
        callback = function(event)
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
              { label = "Create Feature", cmd = create_feature },
            }

            vim.ui.select(commands, {
              prompt = "Flutter Commands",
              format_item = function(item)
                return "🚀 " .. item.label
              end,
            }, function(choice)
              if not choice then return end

              if type(choice.cmd) == "function" then
                choice.cmd()
              elseif type(choice.cmd) == "string" then
                vim.cmd(choice.cmd)
              else
                vim.notify("Invalid command: " .. choice.label, vim.log.levels.ERROR)
              end
            end)
          end, { buffer = event.buf, desc = "Flutter Command Picker" })
        end,
      })
    end,
  },
}
