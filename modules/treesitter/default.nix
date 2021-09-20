{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.treesitter;
in {
  options.vim.treesitter = {
    enable = mkEnableOption "tree-sitter [nvim-treesitter]";
    fold = mkOption {
      description = "enable fold with tree-sitter";
      default = true;
      type = types.bool;
    };

    autotag-html = mkOption {
      description = "enable autoclose and rename html tag [nvim-ts-autotag]";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) (
  let
    writeIf = cond: msg: if cond then msg else "";
  in {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-treesitter
      (if cfg.autotag-html then nvim-ts-autotag else null)
    ];

    vim.configRC = writeIf cfg.fold ''
      " Tree-sitter based folding
      set foldmethod=expr
      set foldexpr=nvim_treesitter#foldexpr()
      set nofoldenable
    '';

    vim.luaConfigRC = ''
      -- Treesitter config
      -- require 'nvim-treesitter.install'.compilers = { "${pkgs.gcc}/bin/gcc" }
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

        ${writeIf cfg.autotag-html ''
          autotag = {
            enable = true,
          },
        ''}
      }
    '';
  });
}
