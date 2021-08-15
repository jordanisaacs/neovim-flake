{
  description = "Jordan's Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # LSP plugins
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    lspsaga = { url = "github:glepnir/lspsaga.nvim"; flake = false; };
    lspkind = { url = "github:onsails/lspkind-nvim"; flake = false; };


    # Langauge server (use master instead of nixpkgs)
    rnix-lsp.url = github:nix-community/rnix-lsp;
    
    # Filetrees
    nvim-tree-lua = { url = "github:kyazdani42/nvim-tree.lua"; flake = false; };

    # Tablines
    nvim-bufferline-lua = { url = "github:akinsho/nvim-bufferline.lua"; flake = false; };

    # Statuslines
    lualine = { url = "github:hoob3rt/lualine.nvim"; flake = false; };

    # Autocompletes
    nvim-compe = { url = "github:hrsh7th/nvim-compe"; flake = false; };

    # Autopairs
    nvim-autopairs = { url = "github:windwp/nvim-autopairs"; flake = false; };
    nvim-ts-autotag = { url = "github:windwp/nvim-ts-autotag"; flake = false; };

    # Icons
    nvim-web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };

    # Buffer tools
    bufdelete-nvim = { url = "github:famiu/bufdelete.nvim"; flake = false; };

    # Themes
    tokyonight = { url = "github:folke/tokyonight.nvim"; flake = false; };
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
          "lspkind"
          "nvim-tree-lua"
          "nvim-bufferline-lua"
          "lualine"
          "nvim-compe"
          "nvim-autopairs"
          "nvim-ts-autotag"
          "nvim-web-devicons"
          "tokyonight"
          "bufdelete-nvim"
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

      defaultApp = apps.nvim;
      defaultPackage = packages.neovimJD;

      overlay = (self: super: {
        inherit neovimBuilder;
        neovimJD = packages.neovimJD;
        neovimPlugins = pkgs.neovimPlugins;
      });

      packages.neovimJD = neovimBuilder {
        config = {
          vim.viAlias = true;
          vim.vimAlias = true;
          vim.lsp = {
            enable = true;
            lspsaga.enable = true;
            rust = true;
            nix = true;
            python = true;
          };


          vim.icons.enable = true;
          vim.icons.nvimWebDevicons = true;
          vim.statusline.lualine.enable = true;
          vim.theme.tokyonight = {
            enable = true;
            style = "night";
          };
          vim.autopairs.enable = true;
          vim.filetree.nvimTreeLua.enable = true;
          vim.tabline.nvimBufferline.enable = true;
          vim.treesitter = {
            enable = true;
            autotag-html = true;
          };
        };
      };
   });
}
