{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./statusline
    ./filetree
    ./themes
    ./icons
    ./lsp
    ./autopairs
    ./snippets
  ];
}
