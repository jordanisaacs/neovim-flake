{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.autocomplete;
in {
  options.vim = {
    autocomplete = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable autocomplete";
      };

      type = mkOption {
        default = "nvim-cmp";
        description = "Set the autocomplete plugin. Options: [nvim-cmp] nvim-compe";
        type = types.enum ["nvim-compe" "nvim-cmp"];
      };
    };
  };

  config = mkIf (cfg.enable) (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = with pkgs.neovimPlugins;
        (
          if cfg.type == "nvim-compe"
          then [nvim-compe]
          else []
        )
        ++ (
          if cfg.type == "nvim-cmp"
          then [
            nvim-cmp
            cmp-buffer
            cmp-vsnip
            cmp-path
            cmp-treesitter
          ]
          else []
        );

      vim.inoremap = mkIf (cfg.type == "nvim-compe") (
        {
          "<silent><expr><C-space>" = "compe#complete()";
          "<silent><expr><C-e>" = "compe#close('<C-e>')";
          "<silent><expr><C-f>" = "compe#scroll({ 'delta': +4 })";
          "<silent><expr><C-d>" = "compe#scroll({ 'delta': -4 })";
        }
        // (
          if (config.vim.autopairs.enable == false)
          then {
            "<silent><expr><CR>" = "compe#confirm('CR')";
          }
          else {}
        )
      );

      vim.configRC = writeIf (cfg.type == "nvim-compe") ''
        set completeopt=menuone,noselect
      '';

      vim.luaConfigRC = ''
        ${writeIf (cfg.type == "nvim-compe") ''
          -- Compe config
          require'compe'.setup {
            enabled = true;
            autocomplete = true;
            debug = false;
            min_length = 1;
            preselect = 'enable';
            throttle_time = 80;
            source_timeout = 200;
            incomplete_delay = 400;
            max_abbr_width = 100;
            max_kind_width = 100;
            max_menu_width = 100;
            documentation = true;

            source = {
               path = true;
               buffer = true;
               calc = true;
               nvim_lsp = true;
               nvim_lua = true;
               vsnip = true;
               ultisnips = true;
            };
          }

          --- Compe tab completion
          local t = function(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
          end

          local check_back_space = function()
              local col = vim.fn.col('.') - 1
              return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
          end

          ---- Use (s-)tab to:
          ----- move to prev/next item in completion menuone
          ----- jump to prev/next snippet's placeholder
          _G.tab_complete = function()
            if vim.fn.pumvisible() == 1 then
              return t "<C-n>"
            ${
            writeIf config.vim.snippets.vsnip.enable ''
              elseif vim.fn['vsnip#available'](1) == 1 then
                return t "<Plug>(vsnip-expand-or-jump)
            ''
          }
            elseif check_back_space() then
              return t "<Tab>"
            else
              return vim.fn['compe#complete']()
            end
          end
          _G.s_tab_complete = function()
            if vim.fn.pumvisible() == 1 then
              return t "<C-p>"
            ${
            writeIf config.vim.snippets.vsnip.enable ''
              elseif vim.fn['vsnip#jumpable'](-1) == 1 then
                return t "<Plug>(vsnip-jump-prev)
            ''
          }
            else
              -- If <S-Tab> is not working in your terminal, change it to <C-h>
              return t "<S-Tab>"
            end
          end

          vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
        ''}

        ${writeIf (cfg.type == "nvim-cmp") ''
          local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end

          local feedkey = function(key, mode)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
          end

          local cmp = require'cmp'
          cmp.setup({
            snippet = {
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
              end,
            },
            sources = {
              ${writeIf (config.vim.lsp.enable) "{ name = 'nvim_lsp' },"}
              ${writeIf (config.vim.lsp.rust.enable) "{ name = 'crates' },"}
              { name = 'vsnip' },
              { name = 'treesitter' },
              { name = 'path' },
              { name = 'buffer' },
            },
            mapping = {
              ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
              ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c'}),
              ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c'}),
              ['<C-y>'] = cmp.config.disable,
              ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
              }),
              ['<CR>'] = cmp.mapping.confirm({
                select = true,
              }),
              ['<Tab>'] = cmp.mapping(function (fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif vim.fn['vsnip#available'](1) == 1 then
                  feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { 'i', 's' }),

              ['<S-Tab>'] = cmp.mapping(function (fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif vim.fn['vsnip#available'](-1) == 1 then
                  feedkeys("<Plug>(vsnip-jump-prev)", "")
                end
              end, { 'i', 's' })
            },
            completion = {
              completeopt = 'menu,menuone,noinsert',
            },
            formatting = {
              format = function(entry, vim_item)
                -- type of kind
                vim_item.kind = ${
            writeIf (config.vim.visuals.lspkind.enable)
            "require('lspkind').presets.default[vim_item.kind] .. ' ' .."
          } vim_item.kind

                -- name for each source
                vim_item.menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  vsnip = "[VSnip]",
                  crates = "[Crates]",
                  path = "[Path]",
                })[entry.source.name]
                return vim_item
              end,
            }
          })
          ${writeIf (config.vim.autopairs.enable && config.vim.autopairs.type == "nvim-autopairs") ''
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { text = ""} }))
          ''}
        ''}
      '';

      vim.snippets.vsnip.enable =
        if (cfg.type == "nvim-cmp")
        then true
        else config.vim.snippets.vsnip.enable;
    }
  );
}
