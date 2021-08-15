
{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
  cfg = config.vim;
in {
  options.vim = {
    colourTerm = mkOption {
      default = true;
      description = "Set terminal up for 256 colours";
      type = types.bool;
    };

    disableArrows = mkOption {
      default = false;
      description = "Set to prevent arrow keys from moving cursor";
      type = types.bool;
    };

    hideSearchHighlight = mkOption {
      default = false;
      description = "Hide search highlight so it doesn't stay highlighted";
      type = types.bool;
    };

    scrollOffset = mkOption {
      default = 8;
      description = "Start scrolling this number of lines from the top or bottom of the page.";
      type = types.int;
    };

    wordWrap = mkOption {
      default = false;
      description = "Enable word wrapping.";
      type = types.bool;
    };

    syntaxHighlighting = mkOption {
      default = true;
      description = "Enable syntax highlighting";
      type = types.bool;
    };

    mapLeaderSpace = mkOption {
      default = true;
      description = "Map the space key to leader key";
      type = types.bool;
    };

    useSystemClipboard = mkOption {
      default = true;
      description = "Make use of the clipboard for default yank and paste operations. Don't use * and +";
      type = types.bool;
    };

    mouseSupport = mkOption {
      default = "a";
      description = "Set modes for mouse support. a - all, n - normal, v - visual, i - insert, c - command";
      type = with types; enum ["a" "n" "v" "i" "c"];
    };

    lineNumberMode = mkOption {
      default = "relNumber";
      description = "How line numbers are displayed. none, relative, number, relNumber";
      type = with types; enum ["relative" "number" "relNumber" "none"];
    };

    preventJunkFiles = mkOption {
      default = false;
      description = "Prevent swapfile, backupfile from being created";
      type = types.bool;
    };

    tabWidth = mkOption {
      default = 4;
      description = "Set the width of tabs";
      type = types.int;
    };

    autoIndent = mkOption {
      default = true;
      description = "Enable auto indent";
      type = types.bool;
    };

    cmdHeight = mkOption {
      default = 1;
      description = "Height of the command pane";
      type = types.int;
    };

    updateTime = mkOption {
      default = 300;
      description = "The number of milliseconds till Cursor Hold event is fired";
      type = types.int;
    };

    showSignColumn = mkOption {
      default = true;
      description = "Show the sign column";
      type = types.bool;
    };

    bell = mkOption {
      default = "none";
      description = "Set how bells are handled. Options: on, visual or none";
      type = types.enum [ "none" "visual" "on" ];
    };

    mapTimeout = mkOption {
      default = 500;
      description = "Timeout in ms that neovim will wait for mapped action to complete";
      type = types.int;
    };

    splitBelow = mkOption {
      default = true;
      description = "New splits will open below instead of on top";
      type = types.bool;
    };

    splitRight = mkOption {
      default = true;
      description = "New splits will open to the right";
      type = types.bool;
    };

  };

  config = (
    let 
      writeIf = cond: msg: if cond then msg else "";
    in {
    
    vim.nmap = if (cfg.disableArrows) then {
      "<up>" = "<nop>";
      "<down>" = "<nop>";
      "<left>" = "<nop>";
      "<right>" = "<nop>";
    } else {};

    vim.imap = if (cfg.disableArrows) then {
      "<up>" = "<nop>";
      "<down>" = "<nop>";
      "<left>" = "<nop>";
      "<right>" = "<nop>";
    } else {};

    vim.nnoremap = if (cfg.mapLeaderSpace) then {
      "<space>" = "<nop>";
    } else {};

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
  });
}
