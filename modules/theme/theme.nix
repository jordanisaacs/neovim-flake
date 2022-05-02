{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.theme;
in {
  options.vim.theme = {
    enable = mkOption {
      type = types.bool;
      description = "Enable Theme";
    };

    name = mkOption {
      type = types.enum ["onedark" "tokyonight"];
      description = ''Name of theme to use: "onedark" "tokyonight"'';
    };

    style = mkOption {
      type = with types; (
        if (cfg.name == "tokyonight")
        then (enum ["day" "night" "storm"])
        else (enum ["dark" "darker" "cool" "deep" "warm" "warmer"])
      );
      description = ''Theme style: "storm", darker variant "night", and "day"'';
    };
  };

  config =
    mkIf cfg.enable
    (
      let
        mkVimBool = val:
          if val
          then "1"
          else "0";
      in {
        vim.configRC = mkIf (cfg.name == "tokyonight") ''
          " need to set style before colorscheme to apply
          let g:${cfg.name}_style = "${cfg.style}"
          colorscheme ${cfg.name}
        '';

        vim.startPlugins = with pkgs.neovimPlugins;
          if (cfg.name == "tokyonight")
          then [tokyonight]
          else [onedark];

        vim.luaConfigRC = mkIf (cfg.name == "onedark") ''
          -- OneDark theme
          require('onedark').setup {
            style = "${cfg.style}"
          }
          require('onedark').load()
        '';
      }
    );
}
