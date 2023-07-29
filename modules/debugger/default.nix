{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.debugger;
in {
  options.vim.debugger = {
    enable = mkEnableOption "LSP, also enabled automatically through null-ls and lspconfig options";

    package = mkOption {
      description = "Package for codelldb";
      type = types.package;
      default = pkgs.vscode-extensions.vadimcn.vscode-lldb;
    };

    port = mkOption {
      description = "Port to start the debugger on";
      type = types.int;
      default = 13000;
    };

    enrichConfig = mkOption {
      description = "Lua script that enriches the config";
      type = types.lines;
      default = "";
      example = nvim.nmd.literalAsciiDoc ''
        [source,lua]
        ---
        if config["cargo"] ~= nil then on_config(cargo_inspector(config)) end
        ---
      '';
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["nvim-dap"];

    vim.luaConfigRC.dap-setup = ''
      local dap = require('dap')

      local codelldb_bin = "${cfg.package}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb"
      local codelldb_lib = "${cfg.package}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so"

      dap.adapters.codelldb = {
        type = 'server',
        port = "${toString cfg.port}",
        executable = {
          command = codelldb_bin,
          args = {"--liblldb", codelldb_lib, "--port", "${toString cfg.port}"},
          enrich_config = function(config, on_config)
            ${cfg.enrichConfig}
          end,
        }
      }

      vim.keymap.set("n", "<leader>do", ":lua require'dap'.repl.open()<CR>")

      vim.keymap.set("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
      vim.keymap.set("n", "<leader>dsn", ":lua require'dap'.step_over()<CR>")
      vim.keymap.set("n", "<leader>dsi", ":lua require'dap'.setp_into()<CR>")
      vim.keymap.set("n", "<leader>dso", ":lua require'dap'.step_out()<CR>")

      vim.keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
      vim.keymap.set("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
      vim.keymap.set("n", "<leader>dp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
    '';
  };
}
