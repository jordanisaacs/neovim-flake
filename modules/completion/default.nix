{ pkgs, lib, config, ... }:
with lib;
with builtins;

let cfg = config.vim.autocomplete;
in {
  options.vim = {
    autocomplete = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = "enable autopairs";
      };

      type = mkOption {
        default = "nvim-cmp";
        description =
          "Set the autopairs type. Options: nvim-autopairs [nvim-autopairs]";
        type = types.enum [ "nvim-compe" "nvim-cmp" ];
      };
    };
  };

  config = mkIf (cfg.enable) (let writeIf = cond: msg: if cond then msg else "";
  in {
    vim.startPlugins = with pkgs.neovimPlugins;
      (if cfg.type == "nvim-compe" then [ nvim-compe ] else [ ])
      ++ (if cfg.type == "nvim-cmp" then [
        nvim-cmp
        cmp-buffer
        cmp-vsnip
        cmp-path
      ] else
        [ ]);

    vim.inoremap = mkIf (cfg.type == "nvim-compe") ({
      "<silent><expr><C-space>" = "compe#complete()";
      "<silent><expr><C-e>" = "compe#close('<C-e>')";
      "<silent><expr><C-f>" = "compe#scroll({ 'delta': +4 })";
      "<silent><expr><C-d>" = "compe#scroll({ 'delta': -4 })";
    } // (if config.vim.autopairs == "none" then {
      "<silent><expr><CR>" = "compe#confirm('CR')";
    } else
      { }));

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
        local check_back_space = function()
          local col = vim.fn.col('.') - 1
          return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
        end

        local t = function(str)
          return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        local cmp = require'cmp'
        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          sources = {
            { name = 'buffer' },
            { name = 'vsnip' },
            { name = 'path' },
            ${writeIf (config.vim.lsp.enable) "{ name = 'nvim_lsp' },"}
            ${writeIf (config.vim.lsp.rust) "{ name = 'crates' },"}
          },
          mapping = {
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }),
            ['<Tab>'] = cmp.mapping(function (fallback)
              if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(t'<C-n>', 'n')
              elseif check_back_space() then
                vim.fn.feedkeys(t'<Tab>', 'n')
              elseif vim.fn['vsnip#available']() == 1 then
                vim.fn.feedkeys(t'<Plug>(vsnip-expand-or-jump)', "")
              else
                fallback()
              end
            end, {
              'i',
              's'
            }),
            ['<S-Tab>'] = cmp.mapping(function (fallback)
              if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(t'<C-p>', 'n')
              elseif check_back_space() then
                vim.fn.feedkeys(t'<Tab>', 'n')
              elseif vim.fn['vsnip#available']() == 1 then
                vim.fn.feedkeys(t'<Plug>(vsnip-jump-prev)', "")
              else
                fallback()
              end
            end, {
              'i',
              's'
            })
          },
          completion = {
            completeopt = 'menu,menuone,noinsert',
          },
          formatting = {
            format = function(entry, vim_item)
              -- type of kind
              vim_item.kind = ${
                writeIf (config.vim.visuals.lspkind)
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
      ''}
    '';

    vim.snippets.vsnip.enable = if (cfg.type == "nvim-cmp") then
      true
    else
      config.vim.snippets.vsnip.enable;
  });
}
