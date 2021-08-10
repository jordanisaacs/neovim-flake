{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.icons;
in {
  options.vim.icons = {
    dev = { enable = mkEnableOption "Enable devicons"; };
    lspkind = { enable = mkEnableOption "Enable vscode-like pictograms for lsp"; };
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (if cfg.dev.enable then nvim-web-devicons else "")
      (if cfg.lspkind.enable then lspkind else "")
    ];

    vim.luaConfigRC = if cfg.lspkind.enable then "require'lspkind'.init()" else "";
  };
}

