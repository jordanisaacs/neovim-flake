# neovim-flake

Nix flake for neovim with configuration options

Originally based on Wil Taylor's amazing [neovim-flake](https://github.com/wiltaylor/neovim-flake)

## Installation

This config is constantly changing and updating as it is my personal config. Some available options may also be broken which will be documented in issues. I recommend cloning the config and running it locally with:

```
nix run .#
```

If you want to live life on the edge you can point to this repository with:

```
nix run github:jordanisaacs/neovim-flake.#
```

## Options

The philosophy behind this flake configuration is sensible options. While the default package has almost everything enabled, when building your own config using the overlay everything is disabled. By enabling a plugin or language, it will set up the keybindings and plugin automatically. Additionally each plugin knows when another plugin is enabled allowing for smart configuration of keybindings and automatic setup of things like completion sources and languages.

A goal of mine is that you should not be able to break neovim by enabling or disabling an option. For example you can't have two completion plugins enabled as the option is an enum.

## Language Support

Most languages use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to set up language server. Additionally some languages also (or exclusively) use [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) to extend capabilities.

### Rust

**LSP Server**: [rust-analyzer](https://github.com/rust-analyzer/rust-analyzer)

**Formatting**

Rust analyzer provides builtin formatting with [rustfmt](https://github.com/rust-lang/rustfmt)

**Plugins**

- [rust-tools](https://github.com/simrat39/rust-tools.nvim)

### Nix

**LSP Server**: [rnix-lsp](https://github.com/nix-community/rnix-lsp)

**Formatting**

rnix provides builtin formatting with [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt)

### SQL

**LSP Server**: [sqls](https://github.com/lighttiger2505/sqls)

**Formatting**

sqls provides formatting but it does not work very well so it is disabled. Instead using [sqlfluff](https://github.com/sqlfluff/sqlfluff) through null-ls. Currently broken, waiting on [issue](https://github.com/jose-elias-alvarez/null-ls.nvim/discussions/231)

**Linting**

Using [sqlfluff](https://github.com/sqlfluff/sqlfluff) through null-ls to provide linting diagnostics set at `information` severity.

**Plugins**

- [sqls.nvim](https://github.com/nanotee/sqls.nvim) for useful actions that leverage `sqls` LSP

### C/C++

**LSP Server**: [ccls](https://github.com/MaskRay/ccls)

### Python

**LSP Server**: [pyright]()

**Formatting**:

Using [black]() through null-ls

### Markdown

**Plugins**

- [glow.nvim](https://github.com/ellisonleao/glow.nvim) for preview directly in neovim buffer (broken, waiting on [issue](https://github.com/ellisonleao/glow.nvim/issues/44))

### HTML

**Plugins**

- [nvim-ts-autotag](https://github.com/ellisonleao/glow.nvim/issues/44) for autoclosing and renaming html tags. Works with html, tsx, vue, svelte, and php


## All Plugins

A list of all plugins that can be enabled

### LSP

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) common configurations for built-in language server
- [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) neovim as a language server to inject LSP diagnostics, code actions, etc.
- [lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim) useful UI and tools for lsp
- [trouble.nvim](https://github.com/folke/trouble.nvim) pretty list of lsp data
- [lsp-signature](https://github.com/ray-x/lsp_signature.nvim) show function signatures as you type

### Buffers

- [nvim-bufferline-lua](https://github.com/akinsho/bufferline.nvim) a buffer line with tab integration
- [bufdelete-nvim](https://github.com/famiu/bufdelete.nvim) delete buffers without losing window layout

### Statuslines

- [lualine.nvim](https://github.com/hoob3rt/lualine.nvim) statusline written in lua.

### Filetrees

- [nvim-tree-lua](https://github.com/kyazdani42/nvim-tree.lua) a file explorer tree written in lua. Using

### Visuals

- [lspkind-nvim](https://github.com/onsails/lspkind-nvim) for pictograms in lsp
- [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) for indentation guides
- [nvim-cursorline]()
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) Plugins and colors for icons. Requires patched font

### Utilities

- [telescope](https://github.com/nvim-telescope/telescope.nvim) an extendable fuzzy finder of lists
- [which-key](https://github.com/folke/which-key.nvim) a popup that displays possible keybindings of command being typed
- [glow.nvim](https://github.com/ellisonleao/glow.nvim) a markdown preview directly in neovim [currently broken]

### Completions

- [nvim-compe](https://github.com/hrsh7th/nvim-compe) A deprecated autocomplete plugin
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) a completion engine that utilizes sources (replaces nvim-compe)
    - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) a source for buffer words
    - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) a source for builtin LSP client
    - [cmp-vsnip](https://github.com/hrsh7th/cmp-vsnip) a source for vim-vsnip autocomplete
    - [cmp-path](https://github.com/hrsh7th/cmp-path) a source for path autocomplete

### Snippets

- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip) a snippet plugin that supports LSP/VSCode's snippet format

### Autopairs

- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) an autopair plugin for neovim
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) uses treesitter to autoclose/rename html tags

### Themes

- [tokyonight-nvim](https://github.com/folke/tokyonight.nvim) a neovim theme with multiple color options

### Dependencies

- [plenary](https://github.com/nvim-lua/plenary.nvim) which is a dependency of some plugins, installed automatically if needed
