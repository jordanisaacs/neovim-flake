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

    glow.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable markdown preview in neovim with glow";
    };
  };

  config = mkIf cfg.enable (mkMerge [
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
