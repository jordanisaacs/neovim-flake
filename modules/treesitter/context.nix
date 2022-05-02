{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.treesitter;
in {
  options.vim.treesitter.context.enable = mkOption {
    type = types.bool;
    description = "enable function context [nvim-treesitter-context]";
  };

  config = mkIf (cfg.enable && cfg.context.enable) (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-treesitter-context
      ];

      vim.luaConfigRC = ''
        -- Treesitter Context config
        require'treesitter-context'.setup {
          enable = true,
          throttle = true,
          max_lines = 0
        }
      '';
    }
  );
}
