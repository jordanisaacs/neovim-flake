{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.statusline.lualine;
in {
  options.vim.statusline.lualine = {
    enable = mkEnableOption "Enable lualine";

    icons = mkOption {
      description = "Enable icons for lualine";
      default = true;
      type = types.bool;

    };

    theme = mkOption {
      description = "Theme for lualine";
      default = "auto";
      type = types.enum (
        [
          "auto"
          "16color"
          "gruvbox"
          "ayu_dark"
          "ayu_light"
          "ayu_mirage"
          "codedark"
          "dracula"
          "everforest"
          "gruvbox"
          "gruvbox_light"
          "gruvbox_material"
          "horizon"
          "iceberg_dark"
          "iceberg_light"
          "jellybeans"
          "material"
          "modus_vivendi"
          "molokai"
          "nightfly"
          "nord"
          "oceanicnext"
          "onedark"
          "onelight"
          "palenight"
          "papercolor_dark"
          "papercolor_light"
          "powerline"
          "seoul256"
          "solarized_dark"
          "tomorrow"
          "wombat"
        ] ++ ( if config.vim.theme.tokyonight.enable == true then [ "tokyonight" ] else [] )
      );
    };

    section-separator = {
      left = mkOption {
        description = "Section separator for left side";
        default = "";
        type = types.str;
      };
      
      right = mkOption {
        description = "Section separator for right side";
        default = "";
        type = types.str;
      };
    };

    component-separator = {
      left = mkOption {
        description = "Component separator for left side";
        default = "⏽";
        type = types.str;
      };
      
      right = mkOption {
        description = "Component separator for right side";
        default = "⏽";
        type = types.str;
      };
    };

    sections = {
      a = mkOption {
        description = "active config for: | (A) | B | C       X | Y | Z |";
        default = "{'mode'}";
        type = types.str;
      };

      b = mkOption {
        description = "active config for: | A | (B) | C       X | Y | Z |";
        default = ''
          {
            {
              "branch",
              separator = '',
            },
            "diff",
          }
        '';
        type = types.str;
      };
      
      c = mkOption {
        description = "active config for: | A | B | (C)       X | Y | Z |";
        default = "{'branch'}";
        type = types.str;
      };

      x = mkOption {
        description = "active config for: | A | B | C       (X) | Y | Z |";
        default = ''
          {
            {
              "diagnostics",
              sources = {'nvim_lsp'},
              separator = '',
              symbols = {error = '', warn = '', info = '', hint = ''},
            },
            {
              "filetype",
            },
            "fileformat",
            "encoding",
          }
        '';
        type = types.str;
      };

      y = mkOption {
        description = "active config for: | A | B | C       X | (Y) | Z |";
        default = "{'progress'}";
        type = types.str;
      };

      z = mkOption {
        description = "active config for: | A | B | C       X | Y | (Z) |";
        default = "{'location'}";
        type = types.str;
      };
    };

    inactive-sections = {
      a = mkOption {
        description = "inactive config for: | (A) | B | C       X | Y | Z |";
        default = "{}";
        type = types.str;
      };

      b = mkOption {
        description = "inactive config for: | A | (B) | C       X | Y | Z |";
        default = "{}";
        type = types.str;
      };
      
      c = mkOption {
        description = "inactive config for: | A | B | (C)       X | Y | Z |";
        default = "{'filename'}";
        type = types.str;
      };

      x = mkOption {
        description = "inactive config for: | A | B | C       (X) | Y | Z |";
        default = "{'location'}";
        type = types.str;
      };

      y = mkOption {
        description = "inactive config for: | A | B | C       X | (Y) | Z |";
        default = "{}";
        type = types.str;
      };

      z = mkOption {
        description = "inactive config for: | A | B | C       X | Y | (Z) |";
        default = ''
          {}
        '';
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ lualine ];
    vim.luaConfigRC = ''
      require'lualine'.setup {
        options = {
          icons_enabled = ${if cfg.icons then (assert config.vim.visuals.nvimWebDevicons == true; "true") else "false"}, 
          theme = "${cfg.theme}",
          component_separators = {"${cfg.component-separator.left}","${cfg.component-separator.right}"},
          section_separators = {"${cfg.component-separator.right}","${cfg.component-separator.left}"},
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = ${cfg.sections.a},
          lualine_b = ${cfg.sections.b},
          lualine_c = ${cfg.sections.c},
          lualine_x = ${cfg.sections.x},
          lualine_y = ${cfg.sections.y},
          lualine_z = ${cfg.sections.z},
        },
        inactive_sections = {
          lualine_a = ${cfg.inactive-sections.a},
          lualine_b = ${cfg.inactive-sections.b},
          lualine_c = ${cfg.inactive-sections.c},
          lualine_x = ${cfg.inactive-sections.x},
          lualine_y = ${cfg.inactive-sections.y},
          lualine_z = ${cfg.inactive-sections.z},
        },
        tabline = {},
        extensions = {${if config.vim.filetree.nvimTreeLua.enable then "\"nvim-tree\"" else ""}},
      }
    '';
  };
}
