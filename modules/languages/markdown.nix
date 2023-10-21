{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.markdown;
in
{
  options.vim.languages.markdown = {
    enable = mkEnableOption "Markdown language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Markdown treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      mdPackage = nvim.options.mkGrammarOption pkgs "markdown";
      mdInlinePackage = nvim.options.mkGrammarOption pkgs "markdown-inline";
    };

    glow.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable markdown preview in neovim with glow";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.mdPackage cfg.treesitter.mdInlinePackage ];
    })
    (mkIf cfg.glow.enable {
      vim.startPlugins = [ "glow-nvim" ];

      vim.luaConfigRC.glow = nvim.dag.entryAnywhere /* lua */ ''
        require'glow'.setup({
          glow_path = "${pkgs.glow}/bin/glow",
        })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "markdown",
          callback = function(args)
            vim.keymap.set('n', '<leader>p', function() vim.cmd('Glow') end)
          end
        })
      '';
    })
  ]);
}
