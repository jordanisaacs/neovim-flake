{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./config.nix
    ./nvim-autopairs.nix
  ];
}
