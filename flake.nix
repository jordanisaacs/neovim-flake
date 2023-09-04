{
  description = "Jordan's Neovim Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # For generating documentation website
    nmd.url = "gitlab:rycee/nmd";
    nmd.flake = false;

    # Language server (use master instead of nixpkgs)
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    rnix-lsp.inputs.nixpkgs.follows = "flake-utils";
    rnix-lsp.inputs.utils.follows = "flake-utils";

    nil.url = "github:jordanisaacs/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";
    nil.inputs.flake-utils.follows = "flake-utils";

    # Tidal cycles
    tidalcycles.url = "github:mitchmindtree/tidalcycles.nix";
    tidalcycles.inputs.vim-tidal-src.url = "github:tidalcycles/vim-tidal";

    ## Plugins (must begin with plugin-)

    # tresitter plugins
    plugin-nvim-treesitter-context.url = "github:nvim-treesitter/nvim-treesitter-context";
    plugin-nvim-treesitter-context.flake = false;

    # LSP plugins
    plugin-nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    plugin-nvim-lspconfig.flake = false;

    plugin-lspsaga.url = "github:tami5/lspsaga.nvim";
    plugin-lspsaga.flake = false;

    plugin-lspkind.url = "github:onsails/lspkind-nvim";
    plugin-lspkind.flake = false;

    plugin-trouble.url = "github:folke/trouble.nvim";
    plugin-trouble.flake = false;

    plugin-nvim-lightbulb.url = "github:kosayoda/nvim-lightbulb";
    plugin-nvim-lightbulb.flake = false;

    plugin-fidget.url = "github:j-hui/fidget.nvim";
    plugin-fidget.flake = false;

    plugin-nvim-code-action-menu.url = "github:weilbith/nvim-code-action-menu";
    plugin-nvim-code-action-menu.flake = false;

    plugin-lsp-signature.url = "github:ray-x/lsp_signature.nvim";
    plugin-lsp-signature.flake = false;

    plugin-null-ls.url = "github:jose-elias-alvarez/null-ls.nvim";
    plugin-null-ls.flake = false;

    plugin-sqls-nvim.url = "github:nanotee/sqls.nvim";
    plugin-sqls-nvim.flake = false;

    plugin-rust-tools.url = "github:simrat39/rust-tools.nvim";
    plugin-rust-tools.flake = false;

    # Debugger
    plugin-nvim-dap.url = "github:mfussenegger/nvim-dap";
    plugin-nvim-dap.flake = false;

    plugin-nvim-dap-ui.url = "github:rcarriga/nvim-dap-ui";
    plugin-nvim-dap-ui.flake = false;

    plugin-nvim-dap-virtual-text.url = "github:theHamsta/nvim-dap-virtual-text";
    plugin-nvim-dap-virtual-text.flake = false;

    # Copying/Registers
    plugin-registers.url = "github:tversteeg/registers.nvim";
    plugin-registers.flake = false;

    plugin-nvim-neoclip.url = "github:AckslD/nvim-neoclip.lua";
    plugin-nvim-neoclip.flake = false;

    # Telescope
    plugin-telescope.url = "github:nvim-telescope/telescope.nvim";
    plugin-telescope.flake = false;

    plugin-telescope-file-browser.url = "github:nvim-telescope/telescope-file-browser.nvim";
    plugin-telescope-file-browser.flake = false;

    # Filetrees
    plugin-nvim-tree-lua.url = "github:kyazdani42/nvim-tree.lua";
    plugin-nvim-tree-lua.flake = false;

    # Tablines
    plugin-nvim-bufferline-lua.url = "github:akinsho/nvim-bufferline.lua?ref=v4.3.0";
    plugin-nvim-bufferline-lua.flake = false;

    # Statuslines
    plugin-lualine.url = "github:hoob3rt/lualine.nvim";
    plugin-lualine.flake = false;

    # Autocompletes
    plugin-nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    plugin-nvim-cmp.flake = false;

    plugin-cmp-buffer.url = "github:hrsh7th/cmp-buffer";
    plugin-cmp-buffer.flake = false;

    plugin-cmp-nvim-lsp.url = "github:hrsh7th/cmp-nvim-lsp";
    plugin-cmp-nvim-lsp.flake = false;

    plugin-cmp-vsnip.url = "github:hrsh7th/cmp-vsnip";
    plugin-cmp-vsnip.flake = false;

    plugin-cmp-path.url = "github:hrsh7th/cmp-path";
    plugin-cmp-path.flake = false;

    plugin-cmp-treesitter.url = "github:ray-x/cmp-treesitter";
    plugin-cmp-treesitter.flake = false;

    plugin-cmp-dap.url = "github:rcarriga/cmp-dap";
    plugin-cmp-dap.flake = false;

    # snippets
    plugin-vim-vsnip.url = "github:hrsh7th/vim-vsnip";
    plugin-vim-vsnip.flake = false;

    # Autopairs
    plugin-nvim-autopairs.url = "github:windwp/nvim-autopairs";
    plugin-nvim-autopairs.flake = false;

    plugin-nvim-ts-autotag.url = "github:windwp/nvim-ts-autotag";
    plugin-nvim-ts-autotag.flake = false;

    # Commenting
    plugin-kommentary.url = "github:b3nj5m1n/kommentary";
    plugin-kommentary.flake = false;

    plugin-todo-comments.url = "github:folke/todo-comments.nvim";
    plugin-todo-comments.flake = false;

    # Buffer tools
    plugin-bufdelete-nvim.url = "github:famiu/bufdelete.nvim";
    plugin-bufdelete-nvim.flake = false;

    # Themes
    plugin-tokyonight.url = "github:folke/tokyonight.nvim";
    plugin-tokyonight.flake = false;

    plugin-onedark.url = "github:navarasu/onedark.nvim";
    plugin-onedark.flake = false;

    plugin-catppuccin.url = "github:catppuccin/nvim";
    plugin-catppuccin.flake = false;

    plugin-dracula-nvim.url = "github:Mofiqul/dracula.nvim";
    plugin-dracula-nvim.flake = false;

    plugin-dracula.url = "github:dracula/vim";
    plugin-dracula.flake = false;

    plugin-gruvbox.url = "github:ellisonleao/gruvbox.nvim";
    plugin-gruvbox.flake = false;

    # Rust crates
    plugin-crates-nvim.url = "github:Saecki/crates.nvim";
    plugin-crates-nvim.flake = false;

    # Visuals
    plugin-nvim-cursorline.url = "github:yamatsum/nvim-cursorline";
    plugin-nvim-cursorline.flake = false;

    plugin-indent-blankline.url = "github:lukas-reineke/indent-blankline.nvim";
    plugin-indent-blankline.flake = false;

    plugin-nvim-web-devicons.url = "github:kyazdani42/nvim-web-devicons";
    plugin-nvim-web-devicons.flake = false;

    plugin-gitsigns-nvim.url = "github:lewis6991/gitsigns.nvim";
    plugin-gitsigns-nvim.flake = false;

    # Key binding help
    plugin-which-key.url = "github:folke/which-key.nvim";
    plugin-which-key.flake = false;

    # Markdown
    plugin-glow-nvim.url = "github:ellisonleao/glow.nvim";
    plugin-glow-nvim.flake = false;

    # Plenary (required by crates-nvim)
    plugin-plenary-nvim.url = "github:nvim-lua/plenary.nvim";
    plugin-plenary-nvim.flake = false;

    plugin-open-browser.url = "github:tyru/open-browser.vim";
    plugin-open-browser.flake = false;

    plugin-plantuml-syntax.url = "github:aklt/plantuml-syntax";
    plugin-plantuml-syntax.flake = false;

    plugin-plantuml-previewer.url = "github:weirongxu/plantuml-previewer.vim";
    plugin-plantuml-previewer.flake = false;
  };

  outputs =
    { nixpkgs
    , flake-utils
    , ...
    } @ inputs:
    let
      rawPlugins = nvimLib.plugins.fromInputs inputs "plugin-";

      neovimConfiguration = { modules ? [ ], ... } @ args:
        import ./modules
          (args // { modules = [{ config.build.rawPlugins = rawPlugins; }] ++ modules; });

      nvimBin = pkg: "${pkg}/bin/nvim";

      buildPkg = pkgs: modules: (neovimConfiguration {
        inherit pkgs modules;
      });

      nvimLib = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib).nvim;

      tidalConfig = {
        config.vim.languages.tidal.enable = true;
      };

      mainConfig = isMaximal:
        let
          overrideable = nixpkgs.lib.mkOverride 1200; # between mkOptionDefault and mkDefault
        in
        {
          config = {
            build.viAlias = overrideable false;
            build.vimAlias = overrideable true;
            vim.languages = {
              enableLSP = overrideable true;
              enableFormat = overrideable true;
              enableTreesitter = overrideable true;
              enableExtraDiagnostics = overrideable true;
              enableDebugger = overrideable true;

              nix.enable = overrideable true;
              markdown.enable = overrideable true;
              html.enable = overrideable isMaximal;
              clang.enable = overrideable isMaximal;
              sql.enable = overrideable isMaximal;
              rust = {
                enable = overrideable isMaximal;
                crates.enable = overrideable true;
              };
              ts.enable = overrideable isMaximal;
              go.enable = overrideable isMaximal;
              zig.enable = overrideable isMaximal;
              python.enable = overrideable isMaximal;
              plantuml.enable = overrideable isMaximal;
              bash.enable = overrideable isMaximal;

              # See tidal config
              tidal.enable = overrideable false;
            };
            vim.lsp = {
              formatOnSave = overrideable true;
              lspkind.enable = overrideable true;
              lightbulb.enable = overrideable true;
              lspsaga.enable = overrideable false;
              nvimCodeActionMenu.enable = overrideable true;
              trouble.enable = overrideable true;
              lspSignature.enable = overrideable true;
            };
            vim.visuals = {
              enable = overrideable true;
              nvimWebDevicons.enable = overrideable true;
              indentBlankline = {
                enable = overrideable true;
                fillChar = overrideable null;
                eolChar = overrideable null;
                showCurrContext = overrideable true;
              };
              cursorWordline = {
                enable = overrideable true;
                lineTimeout = overrideable 0;
              };
            };
            vim.statusline.lualine.enable = overrideable true;
            vim.theme.enable = true;
            vim.autopairs.enable = overrideable true;
            vim.autocomplete = {
              enable = overrideable true;
              type = overrideable "nvim-cmp";
            };
            vim.debugger.ui.enable = overrideable true;
            vim.filetree.nvimTreeLua.enable = overrideable true;
            vim.tabline.nvimBufferline.enable = overrideable true;
            vim.treesitter.context.enable = overrideable true;
            vim.keys = {
              enable = overrideable true;
              whichKey.enable = overrideable true;
            };
            vim.telescope = {
              enable = overrideable true;
              fileBrowser.enable = overrideable true;
            };
            vim.git = {
              enable = overrideable true;
              gitsigns.enable = overrideable true;
              gitsigns.codeActions = overrideable true;
            };
          };
        };

      nixConfig = mainConfig false;
      maximalConfig = mainConfig true;
    in
    {
      lib = {
        nvim = nvimLib;
        inherit neovimConfiguration;
      };

      overlays.default = final: prev: {
        inherit neovimConfiguration;
        neovim-nix = buildPkg prev [ nixConfig ];
        neovim-maximal = buildPkg prev [ maximalConfig ];
        neovim-tidal = buildPkg prev [ tidalConfig ];
      };
    }
    // (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          inputs.tidalcycles.overlays.default
          (final: prev: {
            rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            nil = inputs.nil.packages.${system}.default;
          })
        ];
      };

      docs = import ./docs {
        inherit pkgs;
        nmdSrc = inputs.nmd;
      };

      tidalPkg = buildPkg pkgs [ tidalConfig ];
      nixPkg = buildPkg pkgs [ nixConfig ];
      maximalPkg = buildPkg pkgs [ maximalConfig ];

      devPkg = nixPkg.extendConfiguration {
        modules = [
          {
            vim.syntaxHighlighting = false;
            vim.languages.nix.format.type = "nixpkgs-fmt";
            vim.languages.bash.enable = true;
            vim.languages.html.enable = true;
            vim.filetree.nvimTreeLua.enable = false;
          }
        ];
      };
    in
    {
      apps =
        rec {
          nix = {
            type = "app";
            program = nvimBin nixPkg;
          };
          maximal = {
            type = "app";
            program = nvimBin maximalPkg;
          };
          default = nix;
        }
        // pkgs.lib.optionalAttrs (!(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])) {
          tidal = {
            type = "app";
            program = nvimBin tidalPkg;
          };
        };

      devShells.default = pkgs.mkShell { nativeBuildInputs = [ devPkg ]; };

      packages =
        {
          docs-html = docs.manual.html;
          docs-manpages = docs.manPages;
          docs-json = docs.options.json;
          default = nixPkg;
          nix = nixPkg;
          maximal = maximalPkg;
          develop = devPkg;
        }
        // pkgs.lib.optionalAttrs (!(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])) {
          tidal = tidalPkg;
        };
    }));
}
