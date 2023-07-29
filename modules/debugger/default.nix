{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.debugger;

  truePort =
    if cfg.port == null
    then "\${port}"
    else toString cfg.port;
in {
  options.vim.debugger = {
    enable = mkEnableOption "DAP debugger, also enabled automatically through language options";

    package = mkOption {
      description = "Package for codelldb";
      type = types.package;
      default = pkgs.vscode-extensions.vadimcn.vscode-lldb;
    };

    ui = {
      enable = mkEnableOption "a UI for nvim-dap (nvim-dap-ui)";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.startPlugins = ["nvim-dap"];

      vim.luaConfigRC.dap-setup = nvim.dag.entryAnywhere ''
        local dap = require('dap')

        local codelldb_bin = "${cfg.package}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb"
        local codelldb_lib = "${cfg.package}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so"
        local codelldb = {
          type = "server",
          port = "$${port}",
          executable = {
            command = codelldb_bin,
            args = {"--liblldb", codelldb_lib, "--port", "$${truePort}"},
          }
        }

        dap.adapters.lldb = codelldb;
        dap.adapters.rt_lldb = codelldb;

        vim.keymap.set("n", "<leader>do", require'dap'.repl.open)

        vim.keymap.set("n", "<leader>dc", require'dap'.continue)
        vim.keymap.set("n", "<leader>dsn", require'dap'.step_over)
        vim.keymap.set("n", "<leader>dsi", require'dap'.step_into)
        vim.keymap.set("n", "<leader>dso", require'dap'.step_out)

        vim.keymap.set("n", "<leader>db", require'dap'.toggle_breakpoint)
        vim.keymap.set("n", "<leader>dB", function() require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
        vim.keymap.set("n", "<leader>dp", function() require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
      '';
    }
    (mkIf cfg.ui.enable {
      vim.startPlugins = ["nvim-dap-ui"];

      vim.luaConfigRC.dap-ui = nvim.dag.entryAnywhere ''
        require("dapui").setup()

        vim.keymap.set("n", "<leader>dp", require'dap'.toggle)
      '';
    })
  ]);
}
