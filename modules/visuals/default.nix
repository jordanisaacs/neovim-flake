{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.visuals;
in
{
  options.vim.visuals = {
    enable = mkEnableOption "visual enhancements";

    nvimWebDevicons = mkOption {
      type = types.bool;
      default = false;
      description = "enable dev icons. required for certain plugins [nvim-web-devicons]";
    };

    lspkind = mkOption {
      type = types.bool;
      default = false;
      description = "enable vscode-like pictograms for lsp [lspkind]";
    };

    cursor-wordline = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable word and delayed line highlight [nvim-cursorline]";
      };

      line-timeout = mkOption {
        type = types.int;
        default = 500;
        description = "time in milliseconds for cursorline to appear";
      };
    };

    indent-blankline = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable indentation guides [indent-blankline]";
      };

      listChar = mkOption {
        type = types.str;
        default = "|";
        description = "Character for indentation line";
      };

      fillChar = mkOption {
        type = types.str;
        default = "⋅";
        description = "Character to fill indents";
      };

      eolChar = mkOption {
        type = types.str;
        default = "↴";
        description = "Character at end of line";
      };

      showCurrContext = mkOption {
        type = types.bool;
        default = true;
        description = "Highlight current context from treesitter";
      };

      useTreesitter = mkOption {
        type = types.bool;
        default = true;
        description = "Use treesitter to calculate indentation when possible";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (if cfg.nvimWebDevicons then nvim-web-devicons else null)
      (if cfg.lspkind then lspkind else null)
      (if cfg.cursor-wordline.enable then nvim-cursorline else null)
      (if cfg.indent-blankline.enable then indent-blankline else null)
    ];

    vim.luaConfigRC = ''
      ${if cfg.lspkind then "require'lspkind'.init()" else ""}
      ${if cfg.indent-blankline.enable then ''
        -- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
        vim.wo.colorcolumn = "99999"
        vim.opt.list = true

        local listchars = "${if cfg.indent-blankline.fillChar == "" then "eol:${cfg.indent-blankline.eolChar}" else "eol:${cfg.indent-blankline.eolChar},space:${cfg.indent-blankline.fillChar}"}"
        vim.opt.listchars = listchars;

        require("indent_blankline").setup {
          char = "${cfg.indent-blankline.listChar}",
          use_treesitter = ${toString cfg.indent-blankline.useTreesitter},
          show_current_context = ${toString cfg.indent-blankline.showCurrContext},
          show_end_of_line = true;
        }
      '' else ""}
      ${if cfg.cursor-wordline.enable then "vim.g.cursorline_timeout = ${toString cfg.cursor-wordline.line-timeout}" else ""}
    '';
  };
}
