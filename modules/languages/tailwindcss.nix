{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins;
let
  cfg = config.vim.languages.tailwindcss;

  defaultServer = "tailwindcss-language-server";
  servers = {
    tailwindcss-language-server = {
      package = [ "tailwindcss-language-server" ];

      lspConfig = /*lua*/''
        lspconfig.tailwindcss.setup{
          cmd = {"${nvim.languages.commandOptToCmd cfg.lsp.package "tailwindcss-language-server"}", "--stdio"};
        }
      '';
    };
  };
in
{
  options.vim.languages.tailwindcss = {
    enable = mkEnableOption "TailwindCSS language support";

    lsp = {
      enable = mkOption {
        description = "Enable TailwindCSS LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "TailwindCSS LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = nvim.options.mkCommandOption pkgs {
        description = "TailwindCSS LSP server";
        inherit (servers.${cfg.lsp.server}) package;
      };
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Tailwind treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.options.mkGrammarOption pkgs "tailwindcss";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.tailwindcss-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
