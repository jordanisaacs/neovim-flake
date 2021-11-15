{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.vim.autopairs;
in
{
  options.vim = {
    autopairs = {
      enable = mkOption {
        type = types.bool;
        description = "enable autopairs";
      };

      type = mkOption {
        type = types.enum [ "nvim-autopairs" ];
        description = "Set the autopairs type. Options: nvim-autopairs [nvim-autopairs]";
      };
    };
  };

  config = mkIf cfg.enable
    (
      let
        writeIf = cond: msg: if cond then msg else "";
      in
      {

        vim.startPlugins = with pkgs.neovimPlugins; [
          (if (cfg.type == "nvim-autopairs") then nvim-autopairs else null)
        ];

        vim.luaConfigRC = ''
          ${writeIf (cfg.type == "nvim-autopairs") ''
            ${writeIf cfg.enable ''
              require("nvim-autopairs").setup{}
              ${writeIf (config.vim.completion.type == "nvim-compe") ''
                require('nvim-autopairs.completion.compe').setup({
                  map_cr = true,
                  map_complete = true,
                  auto_select = false,
                })
              ''}
              ${writeIf (config.vim.completion.type == "nvim-cmp") ''
                require('nvim-autopairs.completion.cmp').setup({
                  map_cr = true,
                  map_complete = true,
                  auto_select = false,
                })
              ''}
            ''}
          ''}
        '';
      }
    );
}
