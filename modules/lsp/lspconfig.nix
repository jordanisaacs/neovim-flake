{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.lsp;

in {
  options.vim.lsp = {
    enable = mkEnableOption "neovim lsp support";
    nix = mkEnableOption "Nix LSP";
    rust = mkEnableOption "Rust LSP";
    python = mkEnableOption "Python LSP";
    clang = mkEnableOption "C language LSP";
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg: if cond then msg else "";
    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-lspconfig
        nvim-compe
      ];

      vim.inoremap = {
        "<silent><expr><C-space>" = "compe#complete()";
        "<silent><expr><C-e>" = "compe#close('<C-e>')";
        "<silent><expr><C-f>" = "compe#scroll({ 'delta': +4 })";
        "<silent><expr><C-d>" = "compe#scroll({ 'delta': -4 })";
      } // (if config.vim.autopairs == "none" then {
        "<silent><expr><CR>" = "compe#confirm('CR')";
      }  else {});

      vim.configRC = ''
        set completeopt=menuone,noselect
      '';

      vim.luaConfigRC = ''
        -- Enable lspconfig
        local lspconfig = require'lspconfig'
    
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
          ${writeIf config.vim.snippets.vsnip.enable ''
            elseif vim.fn['vsnip#available'](1) == 1 then
              return t "<Plug>(vsnip-expand-or-jump)
          ''}
          elseif check_back_space() then
            return t "<Tab>"
          else
            return vim.fn['compe#complete']()
          end
        end
        _G.s_tab_complete = function()
          if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
          ${writeIf config.vim.snippets.vsnip.enable ''
            elseif vim.fn['vsnip#jumpable'](-1) == 1 then
              return t "<Plug>(vsnip-jump-prev)
          ''}
          else
            -- If <S-Tab> is not working in your terminal, change it to <C-h>
            return t "<S-Tab>"
          end
        end
    
        vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
        vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
        vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
        vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

        local on_attach = function(client)
        end
    
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
          properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
          }
        }
    
        ${writeIf cfg.rust ''
          -- Rust config
          lspconfig.rust_analyzer.setup{
            capabilities = capabilities;
            on_attach = on_attach;
            cmd = {'${pkgs.rust-analyzer}/bin/rust-analyzer'}
          }
        ''}
    
        ${writeIf cfg.python ''
          -- Python config
          lspconfig.pyright.setup{
            capabilities = capabilities;
            on_attach=on_attach;
            cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
          }
        ''}
    
        ${writeIf cfg.nix ''
          -- Nix config
          lspconfig.rnix.setup{
            capabilities = capabilities;
            on_attach=on_attach;
            cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
          }
        ''}

        ${writeIf cfg.clang ''
          -- CCLS (clang) config
          lspconfig.ccls.setup{
            cmd = {"${pkgs.ccls}/bin/ccls"}
          }
        ''}
      '';
    }
  );
}

