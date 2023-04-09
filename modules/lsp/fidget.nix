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
    fidget = {
      enable = mkEnableOption "UI for nvim-lsp progress";
    };
  };

  config = mkIf (cfg.enable && cfg.fidget.enable) {
    vim.startPlugins = ["fidget"];

    vim.luaConfigRC.fidget = nvim.dag.entryAnywhere ''
      -- Enable fidget
      require'fidget'.setup()
    '';
  };
}
