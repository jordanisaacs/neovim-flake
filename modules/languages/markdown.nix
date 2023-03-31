{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.markdown;
in {
  options.vim.languages.markdown = {
    enable = mkEnableOption "Markdown language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Markdown treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = mkOption {
        description = "Markdown treesitter grammar to use";
        type = types.package;
        default = pkgs.vimPlugins.nvim-treesitter.builtGrammars.markdown;
      };
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
      vim.treesitter.grammars = [cfg.treesitter.package];
    })
    (mkIf cfg.glow.enable {
      vim.startPlugins = ["glow-nvim"];

      vim.globals = {
        "glow_binary_path" = "${pkgs.glow}/bin";
      };

      vim.configRC.glow = nvim.dag.entryAnywhere ''
        autocmd FileType markdown noremap <leader>p :Glow<CR>
      '';
    })
  ]);
}
