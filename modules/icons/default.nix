{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.icons;
in {
  options.vim.icons = {
    enable = mkEnableOption "icons and pictograms";

    nvimWebDevicons = mkOption {
       type = types.bool;
       default = true;
       description = "enable dev icons. required for certain plugins [nvim-web-devicons]";
    };

    lspkind = mkOption {
      default = true;
      type = types.bool;
      description = "enable vscode-like pictograms for lsp [lspkind]";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (if cfg.nvimWebDevicons then nvim-web-devicons else null)
      (if cfg.lspkind then lspkind else null)
    ];

    vim.luaConfigRC = if cfg.lspkind then "require'lspkind'.init()" else "";
  };
}

