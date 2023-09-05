{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.clang;

  defaultServer = "ccls";
  servers = {
    ccls = {
      package = [ "ccls" ];
      lspConfig = ''
        lspconfig.ccls.setup{
          capabilities = capabilities;
          on_attach=default_on_attach;
          cmd = {"${nvim.languages.commandOptToCmd cfg.lsp.package "ccls"}"};
          ${optionalString (cfg.lsp.opts != null) "init_options = ${cfg.lsp.cclsOpts}"}
        }
      '';
    };
  };
in
{
  options.vim.languages.clang = {
    enable = mkEnableOption "C/C++ language support";

    cHeader = mkOption {
      description = ''
        C syntax for headers. Can fix treesitter errors, see:
        https://www.reddit.com/r/neovim/comments/orfpcd/question_does_the_c_parser_from_nvimtreesitter/
      '';
      type = types.bool;
      default = false;
    };

    treesitter = {
      enable = mkOption {
        description = "Enable C/C++ treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      cPackage = nvim.options.mkGrammarOption pkgs "c";
      cppPackage = nvim.options.mkGrammarOption pkgs "cpp";
    };

    lsp = {
      enable = mkOption {
        description = "Enable clang LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "The clang LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = nvim.options.mkCommandOption pkgs {
        description = "clang LSP server";
        inherit (servers.${cfg.lsp.server}) package;
      };
      opts = mkOption {
        description = "Options to pass to clang LSP server";
        type = with types; nullOr str;
        default = null;
      };
      cclsNvim = {
        enable = mkOption {
          description = "Enable support for extra ccls extensions through ccls.nvim";
          default = cfg.lsp.server == "ccls";
          defaultText = nvim.nmd.literalAsciiDoc ''`config.vim.languages.clang.lsp.server == "ccls"`'';
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.cHeader {
      vim.configRC.c-header = nvim.dag.entryAnywhere "let g:c_syntax_for_h = 1";
    })

    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.cPackage cfg.treesitter.cppPackage ];
    })

    (mkIf cfg.lsp.enable (mkMerge [
      {
        vim.lsp.lspconfig.enable = true;
        vim.lsp.lspconfig.sources.clang-lsp = servers.${cfg.lsp.server}.lspConfig;
      }

      (mkIf cfg.lsp.cclsNvim.enable {
        assertions = [{
          assertion = cfg.lsp.server == "ccls";
          message = "To enable cclsNvim, lsp must be enabled and set to ccls";
        }];

        vim.startPlugins = [ "ccls-nvim" ];

        vim.luaConfigRC.ccls-nvim = nvim.dag.entryAnywhere ''
          require("ccls").setup({})
        '';
      })
    ]))
  ]);
}
