{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.git;
in {
  options.vim.git = {
    enable = mkEnableOption "Git support";

    gitsigns = {
      enable = mkEnableOption "gitsigns";

      codeActions = mkEnableOption "gitsigns codeactions through null-ls";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.gitsigns.enable (mkMerge [
      {
        vim.startPlugins = ["gitsigns-nvim"];

        vim.luaConfigRC.gitsigns = nvim.dag.entryAnywhere ''
          require('gitsigns').setup {
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- navigation
              map('n', '<leader>gn', function()
                if vim.wo.diff then return '<leader>gn' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
              end, {expr=true})

              map('n', '<leader>gp', function()
                if vim.wo.diff then return '<leader>gn' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
              end, {expr=true})

              -- actions
              map('n', '<leader>gs', gs.stage_hunk)
              map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)

              map('n', '<leader>gr', gs.reset_hunk)
              map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)

              map('n', '<leader>gp', gs.preview_hunk)
              map('n', '<leader>gu', gs.undo_stage_hunk)

              map('n', '<leader>gS', gs.stage_buffer)
              map('n', '<leader>gR', gs.reset_buffer)

              map('n', '<leader>gd', gs.diffthis)
              map('n', '<leader>gD', function() gs.diffthis('~') end)

              map('n', '<leader>gb', function() gs.blame_line{full=true} end)

              -- Toggles
              map('n', '<leader>gtd', gs.toggle_deleted)
              map('n', '<leader>gtb', gs.toggle_current_line_blame)
              map('n', '<leader>gts', gs.toggle_signs)
              map('n', '<leader>gtn', gs.toggle_numhl)
              map('n', '<leader>gtl', gs.toggle_linehl)
              map('n', '<leader>gtw', gs.toggle_word_diff)

              -- Text objects
              map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
          }
        '';
      }

      (mkIf cfg.gitsigns.codeActions {
        vim.lsp.null-ls.enable = true;
        vim.lsp.null-ls.sources.gitsigns-ca = ''
          table.insert(
            ls_sources,
            null_ls.builtins.code_actions.gitsigns
          )
        '';
      })
    ]))
  ]);
}
