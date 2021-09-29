{ config, lib, pkgs, ... }:
{
  imports = [
    ./completion
    ./themes
    ./core
    ./basic
    ./statusline
    ./tabline
    ./filetree
    ./visuals
    ./lsp
    ./treesitter
    ./autopairs
    ./snippets
    ./keys
    ./markdown
    ./telescope
  ];
}
