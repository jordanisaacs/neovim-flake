{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.bash;

  defaultServer = "bashls";
  servers = {
    bashls = {
      package = [ "nodePackages" "bash-language-server" ];
      lspConfig = ''
        lspconfig.bashls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = {"${nvim.languages.commandOptToCmd cfg.lsp.package "bash-language-server"}", "start"};
        }
      '';
    };
  };

  defaultFormat = "shfmt";
  formats = {
    shfmt = {
      package = [ "shfmt" ];
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.shfmt.with({
            command = "${nvim.languages.commandOptToCmd cfg.format.package "shfmt"}",
          })
        )
      '';
    };
  };

  defaultDiagnostics = [ "shellcheck" ];
  diagnostics = {
    shellcheck = {
      package = pkgs.shellcheck;
      nullConfig = pkg: ''
        table.insert(
          ls_sources,
          null_ls.builtins.diagnostics.shellcheck.with({
            command = "${pkg}/bin/shellcheck",
          })
        )
      '';
    };
  };
in
{
  options.vim.languages.bash = {
    enable = mkEnableOption "Bash language support";

    treesitter = {
      enable = mkOption {
        description = "Bash treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.options.mkGrammarOption pkgs "bash";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Bash LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Bash LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = lib.nvim.options.mkCommandOption pkgs {
        description = "Bash LSP server";
        inherit (servers.${cfg.lsp.server}) package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Bash formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Bash formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };

      package = lib.nvim.options.mkCommandOption pkgs {
        description = "Bash formatter package.";
        inherit (formats.${cfg.format.type}) package;
      };
    };

    extraDiagnostics = {
      enable = mkOption {
        description = "Enable extra Bash diagnostics";
        type = types.bool;
        default = config.vim.languages.enableExtraDiagnostics;
      };
      types = lib.nvim.options.mkDiagnosticsOption {
        langDesc = "Bash";
        inherit diagnostics;
        inherit defaultDiagnostics;
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
      vim.lsp.lspconfig.sources.bash-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.bash-format = formats.${cfg.format.type}.nullConfig;
    })

    (mkIf cfg.extraDiagnostics.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources = lib.nvim.languages.diagnosticsToLua {
        lang = "bash";
        config = cfg.extraDiagnostics.types;
        inherit diagnostics;
      };
    })
  ]);
}
