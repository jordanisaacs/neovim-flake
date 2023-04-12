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
    enable = mkEnableOption "themes";

    name = mkOption {
      description = "Supported themes can be found in `supportedThemes.nix`";
      type = types.enum (attrNames cfg.supportedThemes);
      default = "onedark";
    };

    style = mkOption {
      description = "Specific style for theme if it supports it";
      type = types.enum cfg.supportedThemes.${cfg.name}.styles;
      default = cfg.supportedThemes.${cfg.name}.defaultStyle;
    };

    extraConfig = mkOption {
      description = "Additional lua configuration to add before setup";
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [cfg.name];
    vim.luaConfigRC.themeSetup = nvim.dag.entryBefore ["theme"] cfg.extraConfig;
    vim.luaConfigRC.theme = cfg.supportedThemes.${cfg.name}.setup;
  };
}
