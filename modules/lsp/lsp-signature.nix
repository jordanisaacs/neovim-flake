{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.lsp;
in
{

  options.vim.lsp = {
    lsp-signature = {
      enable = mkEnableOption "lsp signature viewer";
    };
  };

  config = mkIf (cfg.enable && cfg.trouble.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [ lsp-signature ];

    vim.luaConfigRC = ''
      -- Enable lsp signature viewer
      require("lsp_signature").setup()
    '';
  };
}
 
