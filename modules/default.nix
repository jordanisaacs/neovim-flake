{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./completion
    ./theme
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
    ./git
  ];
}
