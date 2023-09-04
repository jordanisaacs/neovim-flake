{ config
, lib
, pkgs
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.debugger;
in
{
  options.vim.debugger = {
    enable = mkEnableOption "DAP debugger, also enabled automatically through language options";

    package = mkPackageOption pkgs [ "codelldb" ] {
      default = [ "vscode-extensions" "vadimcn" "vscode-lldb" ];
    };

    ui = {
      enable = mkEnableOption "a UI for nvim-dap (nvim-dap-ui)";

      autoOpen = mkOption {
        description = "automa open/close the ui when dap starts/ends";
        type = types.bool;
        default = true;
      };
    };

    virtualText.enable = mkEnableOption "virtual text for dap";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.startPlugins = [ "nvim-dap" ];

      vim.luaConfigRC.dap-setup = nvim.dag.entryAnywhere ''
        local dap = require('dap')

        local codelldb_bin = "${cfg.package}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb"
        local codelldb_lib = "${cfg.package}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so"
        local codelldb = {
          type = "server",
          port = "''${port}",
          executable = {
            command = codelldb_bin,
            args = {"--liblldb", codelldb_lib, "--port", "''${port}"},
          }
        }

        dap.adapters.lldb = codelldb;
        dap.adapters.rt_lldb = codelldb;

        vim.keymap.set("n", "<leader>do", dap.repl.open)

        vim.keymap.set("n", "<leader>dc", dap.continue)
        vim.keymap.set("n", "<leader>dsn", dap.step_over)
        vim.keymap.set("n", "<leader>dsi", dap.step_into)
        vim.keymap.set("n", "<leader>dso", dap.step_out)

        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>dB", function() require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
        vim.keymap.set("n", "<leader>dp", function() require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
      '';
    }
    (mkIf cfg.virtualText.enable {
      vim.startPlugins = [ "nvim-dap-virtual-text" ];

      vim.luaConfigRC.dap-virtual-text = nvim.dag.entryAnywhere ''
        require("nvim-dap-virtual-text").setup()
      '';
    })
    (mkIf cfg.ui.enable {
      vim.startPlugins = [ "nvim-dap-ui" ];

      vim.luaConfigRC.dap-ui = nvim.dag.entryAfter [ "dap-setup" ] (''
        local dapui = require"dapui"

        dapui.setup()
        vim.keymap.set("n", "<leader>du", dapui.toggle)
      ''
      + (optionalString cfg.ui.autoOpen ''
        -- TODO: move these into generic events
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end
      ''));
    })
  ]);
}
