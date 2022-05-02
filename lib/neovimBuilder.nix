{
  pkgs,
  lib ? pkgs.lib,
  ...
}: {config}: let
  neovimPlugins = pkgs.neovimPlugins;

  # attempt fix for libstdc++.so.6 no file or directory
  myNeovimUnwrapped = pkgs.neovim-unwrapped.overrideAttrs (prev: {
    propagatedBuildInputs = with pkgs; [pkgs.stdenv.cc.cc.lib];
  });

  vimOptions = lib.evalModules {
    modules = [
      {imports = [../modules];}
      config
    ];

    specialArgs = {
      inherit pkgs;
    };
  };

  vim = vimOptions.config.vim;
in
  pkgs.wrapNeovim myNeovimUnwrapped {
    viAlias = vim.viAlias;
    vimAlias = vim.vimAlias;
    configure = {
      customRC = vim.configRC;

      packages.myVimPackage = with neovimPlugins; {
        start = builtins.filter (f: f != null) vim.startPlugins;
        opt = vim.optPlugins;
      };
    };
  }
