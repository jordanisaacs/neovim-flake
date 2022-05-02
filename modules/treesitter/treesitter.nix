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
      type = types.bool;
      description = "enable tree-sitter [nvim-treesitter]";
    };

    fold = mkOption {
      type = types.bool;
      description = "enable fold with tree-sitter";
    };

    autotagHtml = mkOption {
      type = types.bool;
      description = "enable autoclose and rename html tag [nvim-ts-autotag]";
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-treesitter
        (
          if cfg.autotagHtml
          then nvim-ts-autotag
          else null
        )
      ];

      vim.configRC = writeIf cfg.fold ''
        " Tree-sitter based folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      '';

      vim.luaConfigRC = let
        tree-sitter-hare = builtins.fetchGit {
          url = "https://git.sr.ht/~ecmma/tree-sitter-hare";
          ref = "master";
          rev = "bc26a6a949f2e0d98b7bfc437d459b250900a165";
        };
      in ''
        -- Treesitter config
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            disable = {},
          },

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
