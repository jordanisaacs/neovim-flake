{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.go;

  defaultServer = "gopls";
  servers = {
    gopls = {
      package = [ "gopls" ];
      lspConfig = ''
        lspconfig.gopls.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${nvim.languages.commandOptToCmd cfg.lsp.package "gopls"}", "serve"};
        }
      '';
    };
  };
in
{
  options.vim.languages.go = {
    enable = mkEnableOption "Go language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Go treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.options.mkGrammarOption pkgs "go";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Go LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Go LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = nvim.options.mkCommandOption pkgs {
        description = "Go LSP server";
        inherit (servers.${cfg.lsp.server}) package;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.go-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
