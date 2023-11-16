{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.css;

  defaultServer = "vscode-langservers-extracted";
  servers = {
    vscode-langservers-extracted = {
      package = [ "nodePackages" "vscode-langservers-extracted" ];
      lspConfig = /*lua*/''
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        lspconfig.cssls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${nvim.languages.commandOptToCmd cfg.lsp.package "vscode-css-language-server"}", "--stdio"};
        }
      '';
    };
  };
in
{
  options.vim.languages.css = {
    enable = mkEnableOption "CSS language support";

    lsp = {
      enable = mkOption {
        description = "Enable CSS LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "CSS LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = nvim.options.mkCommandOption pkgs {
        description = "CSS LSP server";
        inherit (servers.${cfg.lsp.server}) package;
      };
    };

    treesitter = {
      enable = mkOption {
        description = "Enable CSS treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.options.mkGrammarOption pkgs "css";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })
    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.css-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
