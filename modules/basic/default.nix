{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim;
in {
  options.vim = {
    colourTerm = mkOption {
      type = types.bool;
      description = "Set terminal up for 256 colours";
    };

    disableArrows = mkOption {
      type = types.bool;
      description = "Set to prevent arrow keys from moving cursor";
    };

    hideSearchHighlight = mkOption {
      type = types.bool;
      description = "Hide search highlight so it doesn't stay highlighted";
    };

    scrollOffset = mkOption {
      type = types.int;
      description = "Start scrolling this number of lines from the top or bottom of the page.";
    };

    wordWrap = mkOption {
      type = types.bool;
      description = "Enable word wrapping.";
    };

    syntaxHighlighting = mkOption {
      type = types.bool;
      description = "Enable syntax highlighting";
    };

    mapLeaderSpace = mkOption {
      type = types.bool;
      description = "Map the space key to leader key";
    };

    useSystemClipboard = mkOption {
      type = types.bool;
      description = "Make use of the clipboard for default yank and paste operations. Don't use * and +";
    };

    mouseSupport = mkOption {
      type = with types; enum ["a" "n" "v" "i" "c"];
      description = "Set modes for mouse support. a - all, n - normal, v - visual, i - insert, c - command";
    };

    lineNumberMode = mkOption {
      type = with types; enum ["relative" "number" "relNumber" "none"];
      description = "How line numbers are displayed. none, relative, number, relNumber";
    };

    preventJunkFiles = mkOption {
      type = types.bool;
      description = "Prevent swapfile, backupfile from being created";
    };

    tabWidth = mkOption {
      type = types.int;
      description = "Set the width of tabs";
    };

    autoIndent = mkOption {
      type = types.bool;
      description = "Enable auto indent";
    };

    cmdHeight = mkOption {
      type = types.int;
      description = "Height of the command pane";
    };

    updateTime = mkOption {
      type = types.int;
      description = "The number of milliseconds till Cursor Hold event is fired";
    };

    showSignColumn = mkOption {
      type = types.bool;
      description = "Show the sign column";
    };

    bell = mkOption {
      type = types.enum ["none" "visual" "on"];
      description = "Set how bells are handled. Options: on, visual or none";
    };

    mapTimeout = mkOption {
      type = types.int;
      description = "Timeout in ms that neovim will wait for mapped action to complete";
    };

    splitBelow = mkOption {
      type = types.bool;
      description = "New splits will open below instead of on top";
    };

    splitRight = mkOption {
      type = types.bool;
      description = "New splits will open to the right";
    };
  };

  config = (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.colourTerm = mkDefault true;
      vim.disableArrows = false;
      vim.hideSearchHighlight = mkDefault false;
      vim.scrollOffset = mkDefault 8;
      vim.wordWrap = mkDefault true;
      vim.syntaxHighlighting = mkDefault true;
      vim.mapLeaderSpace = mkDefault true;
      vim.useSystemClipboard = mkDefault true;
      vim.mouseSupport = mkDefault "a";
      vim.lineNumberMode = mkDefault "relNumber";
      vim.preventJunkFiles = mkDefault false;
      vim.tabWidth = mkDefault 4;
      vim.autoIndent = mkDefault true;
      vim.cmdHeight = mkDefault 1;
      vim.updateTime = mkDefault 300;
      vim.showSignColumn = mkDefault true;
      vim.bell = mkDefault "none";
      vim.mapTimeout = mkDefault 500;
      vim.splitBelow = mkDefault true;
      vim.splitRight = mkDefault true;

      vim.startPlugins = with pkgs.neovimPlugins; [plenary-nvim];

      vim.nmap =
        if (cfg.disableArrows)
        then {
          "<up>" = "<nop>";
          "<down>" = "<nop>";
          "<left>" = "<nop>";
          "<right>" = "<nop>";
        }
        else {};

      vim.imap =
        if (cfg.disableArrows)
        then {
          "<up>" = "<nop>";
          "<down>" = "<nop>";
          "<left>" = "<nop>";
          "<right>" = "<nop>";
        }
        else {};

      vim.nnoremap =
        if (cfg.mapLeaderSpace)
        then {"<space>" = "<nop>";}
        else {};

      vim.configRC = ''
        " Settings that are set for everything
        set encoding=utf-8
        set mouse=${cfg.mouseSupport}
        set tabstop=${toString cfg.tabWidth}
        set shiftwidth=${toString cfg.tabWidth}
        set softtabstop=${toString cfg.tabWidth}
        set expandtab
        set cmdheight=${toString cfg.cmdHeight}
        set updatetime=${toString cfg.updateTime}
        set shortmess+=c
        set tm=${toString cfg.mapTimeout}
        set hidden
        ${writeIf cfg.splitBelow ''
          set splitbelow
        ''}
        ${writeIf cfg.splitRight ''
          set splitright
        ''}
        ${writeIf cfg.showSignColumn ''
          set signcolumn=yes
        ''}
        ${writeIf cfg.autoIndent ''
          set autoindent
        ''}

        ${writeIf cfg.preventJunkFiles ''
          set noswapfile
          set nobackup
          set nowritebackup
        ''}
        ${writeIf (cfg.bell == "none") ''
          set noerrorbells
          set novisualbell
        ''}
        ${writeIf (cfg.bell == "on") ''
          set novisualbell
        ''}
        ${writeIf (cfg.bell == "visual") ''
          set noerrorbells
        ''}
        ${writeIf (cfg.lineNumberMode == "relative") ''
          set relativenumber
        ''}
        ${writeIf (cfg.lineNumberMode == "number") ''
          set number
        ''}
        ${writeIf (cfg.lineNumberMode == "relNumber") ''
          set number relativenumber
        ''}
        ${writeIf cfg.useSystemClipboard ''
          set clipboard+=unnamedplus
        ''}
        ${writeIf cfg.mapLeaderSpace ''
          let mapleader=" "
          let maplocalleader=" "
        ''}
        ${writeIf cfg.syntaxHighlighting ''
          syntax on
        ''}
        ${writeIf (cfg.wordWrap == false) ''
          set nowrap
        ''}
        ${writeIf cfg.hideSearchHighlight ''
          set nohlsearch
          set incsearch
        ''}
        ${writeIf cfg.colourTerm ''
          set termguicolors
          set t_Co=256
        ''}
      '';
    }
  );
}
