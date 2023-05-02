{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    trouble = {
      enable = mkEnableOption "trouble diagnostics viewer";
    };
  };

  config = mkIf (cfg.enable && cfg.trouble.enable) {
    nvim-flake.keymapActions = with nvim.keymap; {
      trouble = {
        toggle = mkVimAction "<cmd>TroubleToggle<CR>";
        workspaceDiagnostics = mkVimAction "<cmd>TroubleToggle workspace_diagnostics<CR>";
        documentDiagnostics = mkVimAction "<cmd>TroubleToggle document_diagnostics<CR>";
        lspReferences = mkVimAction "<cmd>TroubleToggle lsp_references<CR>";
        quickfix = mkVimAction "<cmd>TroubleToggle quickfix<CR>";
        loclist = mkVimAction "<cmd>TroubleToggle loclist<CR>";
      };
    };

    vim.startPlugins = ["trouble"];

    vim.luaConfigRC.trouble = nvim.dag.entryAnywhere ''
      -- Enable trouble diagnostics viewer
      require("trouble").setup {}
    '';
  };
}
