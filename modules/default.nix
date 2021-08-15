{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./statusline
    ./tabline
    ./filetree
    ./themes
    ./icons
    ./lsp
    ./treesitter
    ./autopairs
    ./snippets
  ];
}
