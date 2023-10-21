{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.vim.languages.sclang;
in {
  options.vim.languages.sclang = {
    enable = mkEnableOption "SuperCollider language support and plugins";
    postwin = {
      highlight = mkOption {
        description = ''Use syntax colored post window output'';
        type = types.bool;
        default = true;
      };
      autoToggleError = mkOption {
        description = ''Auto-toggle post window on errors'';
        type = types.bool;
        default = true;
      };
      scrollback = mkOption {
        description = ''The number of lines to save in the post window history'';
        type = types.int;
        default = 5000;
      };
      horizontal = mkOption {
        description = ''Open the post window as a horizontal split'';
        type = types.bool;
        default = false;
      };
      direction = mkOption {
        description = ''Direction of the split: top, right, bot, left'';
        type = types.enum [
          "top"
          "right"
          "bot"
          "left"
        ];
        default = "right";
      };
      float = {
        enable = mkOption {
          description = ''Use a floating post window'';
          type = types.bool;
          default = false;
        };
      };
    };
    editor = {
      forceFtSupercollider = mkOption {
        description = ''Treat .sc files as supercollider. If false, use nvim's native ftdetect'';
        type = types.bool;
        default = true;
      };
      highlight = {
        type = mkOption {
          description = ''Highlight flash type: flash, fade or none'';
          type = types.enum [
            "flash"
            "fade"
            "none"
          ];
          default = "flash";
        };
        flash = {
          duration = mkOption {
            description = ''The duration of the flash in ms'';
            type = types.int;
            default = 100;
          };
          repeats = mkOption {
            description = ''The number of repeats'';
            type = types.int;
            default = 2;
          };
        };
        fade = {
          duration = mkOption {
            description = ''The duration of the flash in ms'';
            type = types.int;
            default = 375;
          };
        };
      };
      signature = {
        float = mkOption {
          description = ''Show function signatures in a floating window'';
          type = types.bool;
          default = true;
        };
        auto = mkOption {
          description = ''Show function signatures while typing in insert mode'';
          type = types.bool;
          default = true;
        };
      };
    };
    statusline = {
      pollInterval = mkOption {
        description = ''The interval to update the status line widgets in seconds'';
        type = types.float;
        default = 1.0;
      };
    };
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "scnvim"
    ];
    vim.luaConfigRC.scnvim = nvim.dag.entryAnywhere /* lua */ ''
      local scnvim = require 'scnvim'
      local map = scnvim.map
      local map_expr = scnvim.map_expr

      scnvim.setup({
        keymaps = {
          ['<M-e>'] = map('editor.send_line', {'i', 'n'}),
          ['<C-e>'] = {
            map('editor.send_block', {'i', 'n'}),
            map('editor.send_selection', 'x'),
          },
          ['<CR>'] = map('postwin.toggle'),
          ['<M-CR>'] = map('postwin.toggle', 'i'),
          ['<M-L>'] = map('postwin.clear', {'n', 'i'}),
          ['<C-k>'] = map('signature.show', {'n', 'i'}),
          ['<F12>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
          ['<leader>st'] = map('sclang.start'),
          ['<leader>sk'] = map('sclang.recompile'),
          ['<F1>'] = map_expr('s.boot'),
          ['<F2>'] = map_expr('s.meter'),
        },

        postwin = {
          highlight = ${boolToString cfg.postwin.highlight},
          auto_toggle_error = ${boolToString cfg.postwin.autoToggleError},
          scrollback = ${toString cfg.postwin.scrollback},
          horizontal = ${boolToString cfg.postwin.horizontal},
          direction = '${cfg.postwin.direction}',
          float = {
            enabled = ${boolToString cfg.postwin.float.enable},
          },
        },

        editor = {
          force_ft_supercollider = ${boolToString cfg.editor.forceFtSupercollider},
          highlight = {
            type = '${cfg.editor.highlight.type}',
            flash = {
              duration = ${toString cfg.editor.highlight.flash.duration},
              repeats = ${toString cfg.editor.highlight.flash.repeats},
            },
            fade = {
              duration = ${toString cfg.editor.highlight.fade.duration},
            },
          },
          signature = {
            float = ${boolToString cfg.editor.signature.float},
            auto = ${boolToString cfg.editor.signature.float},
          },
        },

        statusline = {
          poll_interval = ${strings.floatToString cfg.statusline.pollInterval},
        }
      })
    '';
  };
}
