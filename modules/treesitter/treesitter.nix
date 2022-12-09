{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.treesitter;
in {
  options.vim.treesitter = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "enable tree-sitter [nvim-treesitter]";
    };

    fold = mkOption {
      default = true;
      type = types.bool;
      description = "enable fold with tree-sitter";
    };

    autotagHtml = mkOption {
      default = false;
      type = types.bool;
      description = "enable autoclose and rename html tag [nvim-ts-autotag]";
    };

    grammars = mkOption {
      type = with types; listOf package;
      default = [];
      description = ''
        List of treesitter grammars to install.
        When enabling a language, its treesitter grammar is added for you.
      '';
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = [
        "nvim-treesitter"
        (
          if cfg.autotagHtml
          then "nvim-ts-autotag"
          else null
        )
      ];

      vim.configRC.treesitter = writeIf cfg.fold (nvim.dag.entryAnywhere ''
        " Tree-sitter based folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      '');

      vim.luaConfigRC.treesitter = nvim.dag.entryAnywhere ''
        -- Treesitter config
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            disable = {},
          },

          auto_install = false,
          ensure_isntalled = {},

          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },

          ${writeIf cfg.autotagHtml ''
          autotag = {
            enable = true,
          },
        ''}
        }

        local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
        parser_config.hare = {
          install_info = {
            url = "",
            files = { "" }
          },
          filetype = "ha",
        }
      '';
    }
  );
}
