{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals;
in {
  options.vim.visuals = {
    enable = mkOption {
      type = types.bool;
      description = "visual enhancements";
    };

    nvimWebDevicons.enable = mkOption {
      type = types.bool;
      description = "enable dev icons. required for certain plugins [nvim-web-devicons]";
    };

    lspkind.enable = mkOption {
      type = types.bool;
      description = "";
    };

    cursorWordline = {
      enable = mkOption {
        type = types.bool;
        description = "enable word and delayed line highlight [nvim-cursorline]";
      };

      lineTimeout = mkOption {
        type = types.int;
        description = "time in milliseconds for cursorline to appear";
      };
    };

    indentBlankline = {
      enable = mkOption {
        type = types.bool;
        description = "enable indentation guides [indent-blankline]";
      };

      listChar = mkOption {
        type = types.str;
        description = "Character for indentation line";
      };

      fillChar = mkOption {
        type = types.str;
        description = "Character to fill indents";
      };

      eolChar = mkOption {
        type = types.str;
        description = "Character at end of line";
      };

      showCurrContext = mkOption {
        type = types.bool;
        description = "Highlight current context from treesitter";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.indentBlankline.enable {
      vim.startPlugins = ["indent-blankline"];
      vim.luaConfigRC.indent-blankline = nvim.dag.entryAnywhere ''
        -- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
        vim.wo.colorcolumn = "99999"
        vim.opt.list = true

        ${optionalString (cfg.indentBlankline.eolChar != "") ''
          vim.opt.listchars:append({ eol = "${cfg.indentBlankline.eolChar}" })
        ''}
        ${optionalString (cfg.indentBlankline.fillChar != "") ''
          vim.opt.listchars:append({ eol = "${cfg.indentBlankline.fillChar}" })
        ''}

        require("indent_blankline").setup {
          char = "${cfg.indentBlankline.listChar}",
          show_current_context = ${boolToString cfg.indentBlankline.showCurrContext},
          show_end_of_line = true,
        }
      '';
    })
    (mkIf cfg.cursorWordline.enable {
      vim.startPlugins = ["nvim-cursorline"];
      vim.luaConfigRC.cursorline = nvim.dag.entryAnywhere ''
        vim.g.cursorline_timeout = ${toString cfg.cursorWordline.lineTimeout}
      '';
    })
    (mkIf cfg.nvimWebDevicons.enable {
      vim.startPlugins = ["nvim-web-devicons"];
    })
  ]);
}
