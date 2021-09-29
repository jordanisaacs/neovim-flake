{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    nvim-code-action-menu = {
      enable = mkEnableOption "nvim code action menu";
    };
  };

  config = mkIf (cfg.enable && cfg.nvim-code-action-menu.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-code-action-menu
    ];

    vim.nnoremap = {
      "<silent><leader>ca" = ":CodeActionMenu<CR>";
    };
  };
}
