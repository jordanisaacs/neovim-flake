{config, lib, pkgs, ...}:
{
  imports = [
    ./completion
    ./themes
    ./core
    ./basic
    ./statusline
    ./tabline
    ./filetree
    ./icons
    ./lsp
    ./treesitter
    ./autopairs
    ./snippets
  ];
}
