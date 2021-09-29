{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.lsp;
in {

  options.vim.lsp = {
    trouble = {
        enable = mkEnableOption "trouble diagnostics viewer";
    };
  };

  config = mkIf (cfg.enable && cfg.trouble.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [ trouble ];

    vim.nnoremap = {
      "<leader>xx" = "<cmd>TroubleToggle<CR>";
      "<leader>xw" = "<cmd>TroubleToggle lsp_worskpace_diagnostics<CR>";
      "<leader>xd" = "<cmd>TroubleToggle lsp_document_diagnostics<CR>";
      "<leader>xq" = "<cmd>TroubleToggle quickfix<CR>";
      "<leader>xl" = "<cmd>TroubleToggle loclist<CR>";
      "<leader>xr" = "<cmd>TroubleToggle lsp_references<CR>";
    };

    vim.luaConfigRC = ''
      -- Enable trouble diagnostics viewer
      require("trouble").setup {}
    '';
  };
}
 
