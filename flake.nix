{
  description = "Jordan's Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Vim plugins
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    rnix-lsp.url = github:nix-community/rnix-lsp;
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    lspsaga = { url = "github:glepnir/lspsaga.nvim"; flake = false; };
    nvim-compe = { url = "github:hrsh7th/nvim-compe"; flake = false; };
    lualine = { url = "github:hoob3rt/lualine.nvim"; flake = false; };
    tokyonight = { url = "github:folke/tokyonight.nvim"; flake = false; };
    nvim-web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
    nvim-tree-lua = { url = "github:kyazdani42/nvim-tree.lua"; flake = false; };
    lspkind = { url = "github:onsails/lspkind-nvim"; flake = false; };
    nvim-autopairs = { url = "github:windwp/nvim-autopairs"; flake = false; };
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    # Create a nixpkg for each system
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Plugin must be same as input name
        plugins = [
          "nvim-lspconfig"
          "nvim-treesitter"
          "lspsaga"
          "nvim-compe"
          "lualine"
          "tokyonight"
          "nvim-web-devicons"
          "nvim-tree-lua"
          "lspsaga"
          "lspkind"
          "nvim-autopairs"
        ];
      
        pluginOverlay = lib.buildPluginOverlay;

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [
            pluginOverlay
            (final: prev: {
              rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            })
          ];
        };

        lib = import ./lib { inherit pkgs inputs plugins; };
        
        neovimBuilder = lib.neovimBuilder;
    in
    rec {
      apps = {
        nvim = {
          type = "app";
          program = "${defaultPackage}/bin/nvim";
        };
      };

      # Default app for nix run
      defaultApp = apps.nvim;

      packages.neovimJD = neovimBuilder {
        config = {
            vim.viAlias = true;
            vim.vimAlias = true;
          vim.statusline.lualine.enable = true;
          vim.theme.tokyonight.enable = true;
          vim.autopairs = "nvim-autopairs";
          vim.icons.dev.enable = true;
          vim.icons.lspkind.enable = true;
          vim.filetree.nvimTreeLua.enable = true;
          vim.lsp.enable = true;
          vim.lsp.lspsaga = true;
          vim.lsp.rust = false;
          vim.lsp.nix = true;
          vim.lsp.python = true;
        };
      };

      # Default package output for commands nix shell and build
      defaultPackage = packages.neovimJD;
   });
}
