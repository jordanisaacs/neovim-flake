{
  description = "Jordan's Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Vim plugins
   #  nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
   #  rnix-lsp.url = github:nix-community/rnix-lsp;
   #  nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
   #  nvim-compe = { url = "github:hrsh7th/nvim-compe"; flake = false; };
   #  lualine-nvim = { url = "github:hoob3rt/lualine.nvim"; flake = false; };
   #  tokyonight-nvim = { url = "github:folke/tokyonight.nvim"; flake = false; };
   #  nvim-web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
  };
  
  outputs = { nixpkgs, flake-utils, neovim, ... }@inputs:
    # Create a nixpkg for each system
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Plugin must be same as input name
        plugins = [
          "nvim-lspconfig"
          "nvim-treesitter"
          "nvim-compe"
          "lualine"
          "tokyonight"
          "nvim-web-devicons"
        ];
      
        pluginOverlay = lib.buildPluginOverlay;

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [
            pluginOverlay
            (final: prev: {
              neovim-nightly = neovim.defaultPackage.${system};
              rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            })
          ];
        };

        lib = import ./lib { inherit pkgs inputs plugins; };
        
        neovimBuilder = lib.neovimBuilder;
    in
    rec {
      inherit neovimBuilder pkgs;
      
      apps = {
        nvim = {
          type = "app";
          program = "${defaultPackage}/bin/nvim";
        };
      };

      # Default app for nix run
      defaultApp = apps.nvim;


      packages.neovimWT = neovimBuilder {
        config = {
            vim.viAlias = true;
            vim.vimAlias = true;
          vim.statusline.lualine.enable = true;
          vim.theme.tokyonight.enable = true;
          vim.lsp.enable = true;
          vim.lsp.rust = true;
          vim.lsp.nix = true;
        };
      };

      # Default package output for commands nix shell and build
      defaultPackage = packages.neovimWT;

      overlay = (self: super: {
        inherit neovimBuilder;
        neovimWT = packages.neovimWT;
        neovimPlugins = pkgs.neovimPlugins;
      });
    });
}
