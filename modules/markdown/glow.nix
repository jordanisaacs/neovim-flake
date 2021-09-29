{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.markdown;
in
{
  options.vim.markdown = {
    enable = mkEnableOption "markdown tools and plugins";

    preview = mkOption {
      type = types.bool;
      default = false;
      description = "enable markdown preview in neovim with glow";
    };
  };

  config = mkIf (cfg.enable && cfg.preview) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      glow-nvim
    ];

    vim.configRC = ''
      autocmd FileType markdown noremap <leader>p :Glow<CR>
      let g:glow_binary_path = "${pkgs.glow}/bin"
    '';
  };
}
