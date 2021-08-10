{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.statusline.lualine;
in {
  options.vim.statusline.lualine = {
    enable = mkEnableOption "Enable lualine";

    theme = mkOption {
      description = "Theme for lualine";
      default = "gruvbox";
      type = types.enum (["gruvbox"] ++ (if config.vim.theme.tokyonight.enable == true then ["tokyonight"] else []));
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ lualine ];
    vim.luaConfigRC = ''
      require'lualine'.setup {
        options = {
          theme = ${cfg.theme},
        },
      }
    '';
  };
}
