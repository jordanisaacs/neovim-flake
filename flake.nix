{
  description = "Jordan's Neovim Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # For generating documentation website
    nmd.url = "gitlab:rycee/nmd";
    nmd.flake = false;

    # LSP plugins
    nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    nvim-lspconfig.flake = false;

    lspsaga.url = "github:tami5/lspsaga.nvim";
    lspsaga.flake = false;

    lspkind.url = "github:onsails/lspkind-nvim";
    lspkind.flake = false;

    trouble.url = "github:folke/trouble.nvim";
    trouble.flake = false;

    nvim-treesitter-context.url = "github:nvim-treesitter/nvim-treesitter-context";
    nvim-treesitter-context.flake = false;

    nvim-lightbulb.url = "github:kosayoda/nvim-lightbulb";
    nvim-lightbulb.flake = false;

    fidget.url = "github:j-hui/fidget.nvim";
    fidget.flake = false;

    nvim-code-action-menu.url = "github:weilbith/nvim-code-action-menu";
    nvim-code-action-menu.flake = false;

    lsp-signature.url = "github:ray-x/lsp_signature.nvim";
    lsp-signature.flake = false;

    null-ls.url = "github:jose-elias-alvarez/null-ls.nvim";
    null-ls.flake = false;

    sqls-nvim.url = "github:nanotee/sqls.nvim";
    sqls-nvim.flake = false;

    rust-tools.url = "github:simrat39/rust-tools.nvim";
    rust-tools.flake = false;

    # Copying/Registers
    registers.url = "github:tversteeg/registers.nvim";
    registers.flake = false;

    nvim-neoclip.url = "github:AckslD/nvim-neoclip.lua";
    nvim-neoclip.flake = false;

    # Telescope
    telescope.url = "github:nvim-telescope/telescope.nvim";
    telescope.flake = false;

    # Langauge server (use master instead of nixpkgs)
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    rnix-lsp.inputs.nixpkgs.follows = "flake-utils";
    rnix-lsp.inputs.utils.follows = "flake-utils";

    nil.url = "github:jordanisaacs/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";
    nil.inputs.flake-utils.follows = "flake-utils";

    # Filetrees
    nvim-tree-lua.url = "github:kyazdani42/nvim-tree.lua";
    nvim-tree-lua.flake = false;

    # Tablines
    nvim-bufferline-lua.url = "github:akinsho/nvim-bufferline.lua?ref=v4.3.0";
    nvim-bufferline-lua.flake = false;

    # Statuslines
    lualine.url = "github:hoob3rt/lualine.nvim";
    lualine.flake = false;

    # Autocompletes
    nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    nvim-cmp.flake = false;

    cmp-buffer.url = "github:hrsh7th/cmp-buffer";
    cmp-buffer.flake = false;

    cmp-nvim-lsp.url = "github:hrsh7th/cmp-nvim-lsp";
    cmp-nvim-lsp.flake = false;

    cmp-vsnip.url = "github:hrsh7th/cmp-vsnip";
    cmp-vsnip.flake = false;

    cmp-path.url = "github:hrsh7th/cmp-path";
    cmp-path.flake = false;

    cmp-treesitter.url = "github:ray-x/cmp-treesitter";
    cmp-treesitter.flake = false;

    # snippets
    vim-vsnip.url = "github:hrsh7th/vim-vsnip";
    vim-vsnip.flake = false;

    # Autopairs
    nvim-autopairs.url = "github:windwp/nvim-autopairs";
    nvim-autopairs.flake = false;

    nvim-ts-autotag.url = "github:windwp/nvim-ts-autotag";
    nvim-ts-autotag.flake = false;

    # Commenting
    kommentary.url = "github:b3nj5m1n/kommentary";
    kommentary.flake = false;

    todo-comments.url = "github:folke/todo-comments.nvim";
    todo-comments.flake = false;

    # Buffer tools
    bufdelete-nvim.url = "github:famiu/bufdelete.nvim";
    bufdelete-nvim.flake = false;

    # Themes
    tokyonight.url = "github:folke/tokyonight.nvim";
    tokyonight.flake = false;

    onedark.url = "github:navarasu/onedark.nvim";
    onedark.flake = false;

    catppuccin.url = "github:catppuccin/nvim";
    catppuccin.flake = false;

    dracula-nvim.url = "github:Mofiqul/dracula.nvim";
    dracula-nvim.flake = false;

    dracula.url = "github:dracula/vim";
    dracula.flake = false;

    gruvbox.url = "github:ellisonleao/gruvbox.nvim";
    gruvbox.flake = false;

    # Rust crates
    crates-nvim.url = "github:Saecki/crates.nvim";
    crates-nvim.flake = false;

    # Visuals
    nvim-cursorline.url = "github:yamatsum/nvim-cursorline";
    nvim-cursorline.flake = false;

    indent-blankline.url = "github:lukas-reineke/indent-blankline.nvim";
    indent-blankline.flake = false;

    nvim-web-devicons.url = "github:kyazdani42/nvim-web-devicons";
    nvim-web-devicons.flake = false;

    gitsigns-nvim.url = "github:lewis6991/gitsigns.nvim";
    gitsigns-nvim.flake = false;

    # Key binding help
    which-key.url = "github:folke/which-key.nvim";
    which-key.flake = false;

    # Markdown
    glow-nvim.url = "github:ellisonleao/glow.nvim";
    glow-nvim.flake = false;

    # Tidal cycles
    tidalcycles.url = "github:mitchmindtree/tidalcycles.nix";
    tidalcycles.inputs.vim-tidal-src.url = "github:tidalcycles/vim-tidal";

    # Plenary (required by crates-nvim)
    plenary-nvim.url = "github:nvim-lua/plenary.nvim";
    plenary-nvim.flake = false;

    open-browser.url = "github:tyru/open-browser.vim";
    open-browser.flake = false;

    plantuml-syntax.url = "github:aklt/plantuml-syntax";
    plantuml-syntax.flake = false;

    plantuml-previewer.url = "github:weirongxu/plantuml-previewer.vim";
    plantuml-previewer.flake = false;
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    # Plugin must be same as input name
    availablePlugins = [
      "nvim-treesitter-context"
      "gitsigns-nvim"
      "plenary-nvim"
      "nvim-lspconfig"
      "lspsaga"
      "lspkind"
      "nvim-lightbulb"
      "fidget"
      "lsp-signature"
      "nvim-tree-lua"
      "nvim-bufferline-lua"
      "lualine"
      "nvim-autopairs"
      "nvim-ts-autotag"
      "nvim-web-devicons"
      "tokyonight"
      "bufdelete-nvim"
      "nvim-cmp"
      "cmp-nvim-lsp"
      "cmp-buffer"
      "cmp-vsnip"
      "cmp-path"
      "cmp-treesitter"
      "crates-nvim"
      "vim-vsnip"
      "nvim-code-action-menu"
      "trouble"
      "null-ls"
      "which-key"
      "indent-blankline"
      "nvim-cursorline"
      "sqls-nvim"
      "glow-nvim"
      "telescope"
      "rust-tools"
      "onedark"
      "catppuccin"
      "dracula"
      "dracula-nvim"
      "gruvbox"
      "open-browser"
      "plantuml-syntax"
      "plantuml-previewer"
    ];
    rawPlugins = nvimLib.plugins.inputsToRaw inputs availablePlugins;

    neovimConfiguration = {modules ? [], ...} @ args:
      import ./modules
      (args // {modules = [{config.build.rawPlugins = rawPlugins;}] ++ modules;});

    nvimBin = pkg: "${pkg}/bin/nvim";

    buildPkg = pkgs: modules: (neovimConfiguration {
      inherit pkgs modules;
    });

    nvimLib = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib).nvim;

    tidalConfig = {
      config.vim.languages.tidal.enable = true;
    };

    mainConfig = isMaximal: let
      overrideable = nixpkgs.lib.mkOverride 1200; # between mkOptionDefault and mkDefault
    in {
      config = {
        build.viAlias = overrideable false;
        build.vimAlias = overrideable true;
        vim.languages = {
          enableLSP = overrideable true;
          enableFormat = overrideable true;
          enableTreesitter = overrideable true;
          enableExtraDiagnostics = overrideable true;

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

          # See tidal config
          tidal.enable = overrideable false;
        };
        vim.lsp = {
          formatOnSave = overrideable true;
          lspkind.enable = overrideable false;
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
        vim.filetree.nvimTreeLua.enable = overrideable true;
        vim.tabline.nvimBufferline.enable = overrideable true;
        vim.treesitter.context.enable = overrideable true;
        vim.keys = {
          enable = overrideable true;
          whichKey.enable = overrideable true;
        };
        vim.telescope.enable = overrideable true;
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
        neovim-nix = buildPkg prev [nixConfig];
        neovim-maximal = buildPkg prev [maximalConfig];
        neovim-tidal = buildPkg prev [tidalConfig];
      };
    }
    // (flake-utils.lib.eachDefaultSystem (system: let
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

      tidalPkg = buildPkg pkgs [tidalConfig];
      nixPkg = buildPkg pkgs [nixConfig];
      maximalPkg = buildPkg pkgs [maximalConfig];

      devPkg = nixPkg.extendConfiguration {
        modules = [
          {config.vim.languages.html.enable = true;}
        ];
      };
    in {
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
        // pkgs.lib.optionalAttrs (!(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])) {
          tidal = {
            type = "app";
            program = nvimBin tidalPkg;
          };
        };

      devShells.default = pkgs.mkShell {nativeBuildInputs = [devPkg];};

      packages =
        {
          docs-html = docs.manual.html;
          docs-manpages = docs.manPages;
          docs-json = docs.options.json;
          default = nixPkg;
          nix = nixPkg;
          maximal = maximalPkg;
        }
        // pkgs.lib.optionalAttrs (!(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])) {
          tidal = tidalPkg;
        };
    }));
}
