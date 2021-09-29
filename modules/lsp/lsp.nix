{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.lsp;

in
{
  options.vim.lsp = {
    enable = mkEnableOption "neovim lsp support";
    nix = mkEnableOption "Nix LSP";
    rust = mkEnableOption "Rust LSP";
    python = mkEnableOption "Python LSP";
    clang = mkEnableOption "C language LSP";
    sql = mkEnableOption "SQL Language LSP";
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg: if cond then msg else "";
    in
    {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-lspconfig
        null-ls
        (if (config.vim.autocomplete.enable && (config.vim.autocomplete.type == "nvim-cmp")) then cmp-nvim-lsp else null)
        (if cfg.sql then sqls-nvim else null)
      ] ++ (if cfg.rust then [
        crates-nvim
        rust-tools
      ] else [ ]);


      vim.configRC =
        if cfg.rust then ''
          function! MapRustTools()
            nnoremap <silent>ri <cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>
            nnoremap <silent>rr <cmd>lua require('rust-tools.runnables').runnables()<CR>
            nnoremap <silent>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
            nnoremap <silent>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
            nnoremap <silent>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
          endfunction
        
          autocmd filetype rust nnoremap <silent>ri <cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>
          autocmd filetype rust nnoremap <silent>rr <cmd>lua require('rust-tools.runnables').runnables()<CR>
          autocmd filetype rust nnoremap <silent>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
          autocmd filetype rust nnoremap <silent>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
          autocmd filetype rust nnoremap <silent>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
        '' else "";

      vim.luaConfigRC = ''
        local null_ls = require("null-ls")

        local ls_sources = {
          ${writeIf cfg.python ''
            null_ls.builtins.formatting.black.with({
              command = "${pkgs.black}/bin/black",
            }),
          ''}
        }

        -- Enable null-ls
        null_ls.config({
          diagnostics_format = "[#{m}] #{s} (#{c})",
          debounce = 250,
          default_timeout = 5000,
          sources = ls_sources,
        })

        -- Enable formatting on save using null-ls
        local save_format = function(client)
          if client.resolved_capabilities.document_formatting then
            vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
          end
        end

        local default_on_attach = function(client)
          save_format(client)
        end

        require('lspconfig')['null-ls'].setup({ on_attach=default_on_attach })

        -- Enable lspconfig
        local lspconfig = require('lspconfig')

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        ${ if config.vim.autocomplete.enable then
          (
            if config.vim.autocomplete.type == "nvim-compe" then ''
              vim.capabilities.textDocument.completion.completionItem.snippetSupport = true
              capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = {
                  'documentation',
                  'detail',
                  'additionalTextEdits',
                }
              }
            '' else ''
              capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
            ''
          ) else ""}
    
        ${writeIf
        cfg.rust
        ''
          -- Rust config
          lspconfig.rust_analyzer.setup{}
          
          local rustopts = {
            server = {
              capabilities = capabilities;
              on_attach = default_on_attach;
              cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"}
            }
          }

          require('crates').setup{}
          require('rust-tools').setup(rustopts)
          require('rust-tools.inlay_hints').set_inlay_hints()
        ''}
    
        ${writeIf
        cfg.python
        ''
          -- Python config
          lspconfig.pyright.setup{
            capabilities = capabilities;
            on_attach=default_on_attach;
            cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
          }
        ''}
    
        ${writeIf
        cfg.nix
        ''
          -- Nix config
          lspconfig.rnix.setup{
            capabilities = capabilities;
            on_attach=default_on_attach;
            cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
          }
        ''}

        ${writeIf
        cfg.clang
        ''
          -- CCLS (clang) config
          lspconfig.ccls.setup{
            cmd = {"${pkgs.ccls}/bin/ccls"}
          }
        ''}

        ${writeIf
        cfg.sql
        ''
          -- SQLS config
          lspconfig.sqls.setup {
            on_attach = function(client)
              client.resolved_capabilities.execute_command = true
              client.resolved_capabilities.document_formatting = false

              require'sqls'.setup{}
            end,
            cmd = {"${pkgs.sqls}/bin/sqls", "-config", string.format("%s/config.yml", vim.fn.getcwd()) }
          }
        ''}


      '';
    }
  );
}

