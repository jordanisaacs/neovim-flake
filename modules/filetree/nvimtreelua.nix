{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.filetree.nvimTreeLua;
in {
  imports = [
    (mkRemovedOptionModule ["openOnSetup"] ''
      `open_on_setup*` options have been removed from nvim-tree-lua.
      see https://github.com/nvim-tree/nvim-tree.lua/issues/1669
    '')
  ];
  options.vim.filetree.nvimTreeLua = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nvim-tree-lua";
    };

    treeSide = mkOption {
      default = "left";
      description = "Side the tree will appear on left or right";
      type = types.enum ["left" "right"];
    };

    treeWidth = mkOption {
      default = 25;
      description = "Width of the tree in charecters";
      type = types.int;
    };

    hideFiles = mkOption {
      default = [".git" "node_modules" ".cache"];
      description = "Files to hide in the file view by default.";
      type = with types; listOf str;
    };

    hideIgnoredGitFiles = mkOption {
      default = false;
      description = "Hide files ignored by git";
      type = types.bool;
    };

    closeOnLastWindow = mkOption {
      default = true;
      description = "Close when tree is last window open";
      type = types.bool;
    };

    ignoreFileTypes = mkOption {
      default = [];
      description = "Ignore file types";
      type = with types; listOf str;
    };

    closeOnFileOpen = mkOption {
      default = false;
      description = "Closes the tree when a file is opened.";
      type = types.bool;
    };

    resizeOnFileOpen = mkOption {
      default = false;
      description = "Resizes the tree when opening a file.";
      type = types.bool;
    };

    followBufferFile = mkOption {
      default = true;
      description = "Follow file that is in current buffer on tree";
      type = types.bool;
    };

    indentMarkers = mkOption {
      default = true;
      description = "Show indent markers";
      type = types.bool;
    };

    hideDotFiles = mkOption {
      default = false;
      description = "Hide dotfiles";
      type = types.bool;
    };

    openTreeOnNewTab = mkOption {
      default = false;
      description = "Opens the tree view when opening a new tab";
      type = types.bool;
    };

    disableNetRW = mkOption {
      default = false;
      description = "Disables netrw and replaces it with tree";
      type = types.bool;
    };

    hijackNetRW = mkOption {
      default = true;
      description = "Prevents netrw from automatically opening when opening directories";
      type = types.bool;
    };

    trailingSlash = mkOption {
      default = true;
      description = "Add a trailing slash to all folders";
      type = types.bool;
    };

    groupEmptyFolders = mkOption {
      default = true;
      description = "Compact empty folders trees into a single item";
      type = types.bool;
    };

    lspDiagnostics = mkOption {
      default = true;
      description = "Shows lsp diagnostics in the tree";
      type = types.bool;
    };

    systemOpenCmd = mkOption {
      default = "${pkgs.xdg-utils}/bin/xdg-open";
      description = "The command used to open a file with the associated default program";
      type = types.str;
    };

    keymap = nvim.keymap.mkKeymapOptions;
  };

  config = let
    actions = with nvim.keymap; {
      toggle = mkVimAction ":NvimTreeToggle<CR>";
      refresh = mkVimAction ":NvimTreeRefresh<CR>";
      findFile = mkVimAction ":NvimTreeFindFile<CR>";
      findFileToggle = mkVimAction ":NvimTreeFindFileToggle<CR>";
      focus = mkVimAction ":NvimTreeFocus<CR>";
    };
  in
    mkIf cfg.enable {
      nvim-flake.keymapActions = {nvimTreeLua = actions;};
      vim.startPlugins = ["nvim-tree-lua"];

      vim.luaConfigRC.nvimtreelua = nvim.dag.entryAnywhere ''
        require'nvim-tree'.setup({
          disable_netrw = ${boolToString cfg.disableNetRW},
          hijack_netrw = ${boolToString cfg.hijackNetRW},
          open_on_tab = ${boolToString cfg.openTreeOnNewTab},
          open_on_setup = ${boolToString cfg.openOnSetup},
          open_on_setup_file = ${boolToString cfg.openOnSetup},
          system_open = {
            cmd = ${"'" + cfg.systemOpenCmd + "'"},
          },
          diagnostics = {
            enable = ${boolToString cfg.lspDiagnostics},
          },
          view  = {
            width = ${toString cfg.treeWidth},
            side = ${"'" + cfg.treeSide + "'"},
          },
          tab = {
            sync = {
              open = ${boolToString cfg.openTreeOnNewTab}
            },
          },
          renderer = {
            indent_markers = {
              enable = ${boolToString cfg.indentMarkers},
            },
            add_trailing = ${boolToString cfg.trailingSlash},
            group_empty = ${boolToString cfg.groupEmptyFolders},
          },
          actions = {
            open_file = {
              quit_on_open = ${boolToString cfg.closeOnFileOpen},
              resize_window = ${boolToString cfg.resizeOnFileOpen},
            },
          },
          git = {
            enable = true,
            ignore = ${boolToString cfg.hideIgnoredGitFiles},
          },
          filters = {
            dotfiles = ${boolToString cfg.hideDotFiles},
            custom = {
              ${builtins.concatStringsSep "\n" (builtins.map (s: "\"" + s + "\",") cfg.hideFiles)}
            },
          },
        })
      '';
    };
}
