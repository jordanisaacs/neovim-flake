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
    vim.startPlugins = with pkgs.neovimPlugins; [nvim-lightbulb];

    vim.luaConfigRC = ''
      -- Enable trouble diagnostics viewer
      require("trouble").setup {}
    '';
  };
}
