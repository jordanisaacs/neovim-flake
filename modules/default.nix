{config, lib, pkgs, ...}:
{
  imports = [
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
