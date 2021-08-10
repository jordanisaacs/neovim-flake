{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.vim;
in {
  options.vim = {
    autopairs = mkOption {
      default = "none";
      description = "Set the autopairs type. Options: none, nvim-autopairs";
      type = types.enum [ "none" "nvim-autopairs" ];
    };
  };

  config = mkIf (cfg.autopairs == "nvim-autopairs") {
    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-autopairs ];

    vim.luaConfigRC = ''
      require('nvim-autopairs').setup{}
      require('nvim-autopairs.completion.compe').setup({
        map_cr = true,
        map_complete = true,
        auto_select = false,
      })
    '';
  };
}
