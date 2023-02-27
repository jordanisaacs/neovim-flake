{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.tmux-navigator;
in {
  options.vim = {
    tmux-navigator = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable tmux-navigator, this plugin will only work together with tmuxPlugins.vim-tmux-navigator";
      };

      autosave-on-leave = mkOption {
        type = types.enum ["disabled" "update" "wall"];
        default = "disabled";
        description = "enable autosave when navigating to tmux";
      };

      disable-when-zoomed = mkOption {
        type = types.bool;
        default = false;
        description = "disable navigator when the tmux pane is zoomed";
      };

      preserve-zoom = mkOption {
        type = types.bool;
        default = false;
        description = "preserve zoom when moving from ";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [
      "tmux-navigator"
    ];

    vim.configRC.tmux-navigator = nvim.dag.entryAnywhere ''
      ${optionalString (cfg.autosave-on-leave == "update") "let g:tmux_navigator_save_on_switch = 1"}
      ${optionalString (cfg.autosave-on-leave == "wall") "let g:tmux_navigator_save_on_switch = 2"}
      ${optionalString (cfg.disable-when-zoomed) "let g:tmux_navigator_disable_when_zoomed = 1"}
      ${optionalString (cfg.preserve-zoom) "let g:tmux_navigator_preserve_zoom  = 1"}
    '';
  };
}
