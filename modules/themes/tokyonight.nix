{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.theme.tokyonight;
in {

  options.vim.theme.tokyonight = {
    enable = mkEnableOption "Enable Tokyo Night Theme";
    
    style = mkOption {
      description = ''Theme style: "storm", darker variant "night", and "day"'';
      default = "storm";
      type = types.enum [ "day" "night" "storm" ];
    };
  };

  config = mkIf cfg.enable (
    let
      mkVimBool = val: if val then "1" else "0";
    in {
      vim.configRC = ''
        colorscheme tokyonight
      '';

      vim.startPlugins = with pkgs.neovimPlugins; [tokyonight];

      vim.globals = {
        "tokyonight_style" = cfg.style;
      };
    }
  );
}
 
