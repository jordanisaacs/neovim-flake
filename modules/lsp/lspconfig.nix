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
        (if (config.vim.autocomplete.enable && (config.vim.autocomplete.type == "nvim-cmp")) then cmp-nvim-lsp else null)
        (if cfg.rust then crates-nvim else null)
      ];


      vim.luaConfigRC = ''
        -- Enable lspconfig
        local lspconfig = require'lspconfig'
    
    

        local on_attach = function(client)
        end
    
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        ${ if config.vim.autocomplete.enable then (
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
    
        ${writeIf cfg.rust ''
          -- Rust config
          lspconfig.rust_analyzer.setup{
            capabilities = capabilities;
            on_attach = on_attach;
            cmd = {'${pkgs.rust-analyzer}/bin/rust-analyzer'}
          }

          require('crates').setup{}
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

