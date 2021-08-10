{ pkgs, lib ? pkgs.lib, ...}:

{ config }:
let
  neovimPlugins = pkgs.neovimPlugins;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [../modules]; }
      config 
    ];

    specialArgs = {
      inherit pkgs; 
    };
  };

  vim = vimOptions.config.vim;
in pkgs.wrapNeovim pkgs.neovim-unwrapped {
  viAlias = true;
  vimAlias = true;
  configure = {
    customRC = vim.configRC;

    packages.myVimPackage = with pkgs.vimPlugins; {
      start = vim.startPlugins;
      opt = vim.optPlugins;
    };
  };
}
