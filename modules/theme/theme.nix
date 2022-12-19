{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.attrsets;
with builtins; let
  cfg = config.vim.theme;
in {
  options.vim.theme = {
    enable = mkOption {
      type = types.bool;
      description = "Enable Theme";
    };

    name = mkOption {
      type = types.enum (attrNames cfg.supportedThemes);
      description = "Supported themes can be found in `supportedThemes.nix`";
    };

    style = mkOption {
      type = with types; nullOr (enum cfg.supportedThemes.${cfg.name}.styles);
      description = "Specific style for theme if it supports it";
      default = null; 
    };

    extraConfig = mkOption {
      type = with types; lines;
      description = "Additional lua configuration to add before setup";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [cfg.name];
    vim.luaConfigRC.themeSetup = nvim.dag.entryBefore ["theme"] cfg.extraConfig;
    vim.luaConfigRC.theme = cfg.supportedThemes.${cfg.name}.setup;
  };
}
