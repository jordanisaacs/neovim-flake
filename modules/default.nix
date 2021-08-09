{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./statusline
    ./filetree
    ./themes
    ./lsp
  ];
}
