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

### Markdown

**Plugins**

- [glow.nvim](https://github.com/ellisonleao/glow.nvim) for preview directly in neovim buffer (broken, waiting on [issue](https://github.com/ellisonleao/glow.nvim/issues/44))

### HTML

**Plugins**

- [nvim-ts-autotag](https://github.com/ellisonleao/glow.nvim/issues/44) for autoclosing and renaming html tags. Works with html, tsx, vue, svelte, and php


## General Plugins

To Document

### Themes

- [tokyonight-nvim](https://github.com/folke/tokyonight.nvim)
