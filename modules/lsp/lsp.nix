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
    rust = {
      enable = mkEnableOption "Rust LSP";
      rustAnalyzerOpts = mkOption {
        type = types.str;
        default = ''
          ["rust-analyzer"] = {
            experimental = {
              procAttrMacros = true,
            },
          },
        '';
        description = "options to pass to rust analyzer";
      };
    };
    python = mkEnableOption "Python LSP";
    clang = mkEnableOption "C language LSP";
    sql = mkEnableOption "SQL Language LSP";
    go = mkEnableOption "Go language LSP";
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
      ] ++ (if cfg.rust.enable then [
        crates-nvim
        rust-tools
      ] else [ ]);


      vim.configRC = ''
        ${if cfg.rust.enable then ''
          function! MapRustTools()
            nnoremap <silent><leader>ri <cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>
            nnoremap <silent><leader>rr <cmd>lua require('rust-tools.runnables').runnables()<CR>
            nnoremap <silent><leader>>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
            nnoremap <silent><leader>>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
            nnoremap <silent><leader>>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
          endfunction
        
          autocmd filetype rust nnoremap <silent><leader>ri <cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>
          autocmd filetype rust nnoremap <silent><leader>rr <cmd>lua require('rust-tools.runnables').runnables()<CR>
          autocmd filetype rust nnoremap <silent><leader>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
          autocmd filetype rust nnoremap <silent><leader>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
          autocmd filetype rust nnoremap <silent><leader>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
        '' else ""}

        ${if cfg.nix then ''
          autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
        '' else ""}

        ${if cfg.clang then ''
          " c syntax for header (otherwise breaks treesitter highlighting) 
          " https://www.reddit.com/r/neovim/comments/orfpcd/question_does_the_c_parser_from_nvimtreesitter/
          let g:c_syntax_for_h = 1
        '' else ""}
      '';
      vim.luaConfigRC = ''
        local null_ls = require("null-ls")
        local null_helpers = require("null-ls.helpers")
        local null_methods = require("null-ls.methods")

        local ls_sources = {
          ${writeIf cfg.python ''
            null_ls.builtins.formatting.black.with({
              command = "${pkgs.black}/bin/black",
            }),
          ''}
          -- Commented out for now
          --${writeIf (config.vim.git.enable && config.vim.git.gitsigns.enable) ''
          --  null_ls.builtins.code_actions.gitsigns,
          --''}
          ${writeIf cfg.sql ''
            null_helpers.make_builtin({
              method = null_methods.internal.FORMATTING,
              filetypes = { "sql" },
              generator_opts = {
                to_stdin = true,
                ignore_stderr = true,
                suppress_errors = true,
                command = "${pkgs.sqlfluff}/bin/sqlfluff",
                args = {
                  "fix",
                  "-",
                },
              },
              factory = null_helpers.formatter_factory,
            }),

            null_helpers.make_builtin({
              method = null_methods.internal.DIAGNOSTICS,
              filetypes = { "sql" },
              generator_opts = {
                command = "${pkgs.sqlfluff}/bin/sqlfluff",
                args = {
                  "lint",
                  "--format",
                  "json",
                  "-",
                },
                to_stdin = true,
                from_stderr = true,
                format = "json",
                on_output = function(params)
                  params.messages = params and params.output and params.output[1] and params.output[1].violations or {}

                  local diagnostics = {}
                  for _, json_diagnostic in ipairs(params.messages) do
                    local diagnostic = {
                      row = json_diagnostic["line_no"],
                      col = json_diagnostic["line_pos"],
                      code = json_diagnostic["code"],
                      message = json_diagnostic["description"],
                      severity = null_helpers.diagnostics.severities["information"],
                    }

                    table.insert(diagnostics, diagnostic)
                  end

                  return diagnostics
                end,
              },
              factory = null_helpers.generator_factory,
            })
          ''}
        }

        -- Enable formatting
        save_format = function(client)
          if client.resolved_capabilities.document_formatting then
            vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
          end
        end

        default_on_attach = function(client)
          save_format(client)
        end

        -- Enable null-ls
        require('null-ls').setup({
          diagnostics_format = "[#{m}] #{s} (#{c})",
          debounce = 250,
          default_timeout = 5000,
          sources = ls_sources,
          on_attach=default_on_attach
        })

        -- Enable lspconfig
        local lspconfig = require('lspconfig')

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        ${if config.vim.autocomplete.enable then (if config.vim.autocomplete.type == "nvim-compe" then ''
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
        '') else ""}

        ${writeIf cfg.rust.enable ''
          -- Rust config
          
          local rustopts = {
            server = {
              capabilities = capabilities,
              on_attach = default_on_attach,
              cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"},
              settings = {
                ${cfg.rust.rustAnalyzerOpts}
              }
            }
          }

          lspconfig.rust_analyzer.setup{}
          require('crates').setup{}
          require('rust-tools').setup(rustopts)
          require('rust-tools.inlay_hints').set_inlay_hints()
        ''}
    
        ${writeIf cfg.python ''
          -- Python config
          lspconfig.pyright.setup{
            capabilities = capabilities;
            on_attach=default_on_attach;
            cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
          }
        ''}
    
        ${writeIf cfg.nix ''
          -- Nix config
          lspconfig.rnix.setup{
            capabilities = capabilities;
            on_attach=default_on_attach;
            cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
          }
        ''}

        ${writeIf cfg.clang ''
          -- CCLS (clang) config
          lspconfig.ccls.setup{
            capabilities = capabilities;
            on_attach=default_on_attach;
            cmd = {"${pkgs.ccls}/bin/ccls"}
          }
        ''}

        ${writeIf cfg.sql ''
          -- SQLS config
          lspconfig.sqls.setup {
            on_attach = function(client)
              client.resolved_capabilities.execute_command = true
              -- use null-ls with sqlfluff instead
              client.resolved_capabilities.document_formatting = false

              require'sqls'.setup{}
            end,
            cmd = {"${pkgs.sqls}/bin/sqls", "-config", string.format("%s/config.yml", vim.fn.getcwd()) }
          }
        ''}

        ${writeIf cfg.go ''
          -- Go config
          lspconfig.gopls.setup {
            capabilities = capabilities;
            on_attach = default_on_attach;
            cmd = {"${pkgs.gopls}/bin/gopls", "serve"},
          }
        ''}
      '';
    }
  );
}

