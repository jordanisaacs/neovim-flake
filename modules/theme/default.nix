{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./theme.nix
    ./supported_themes.nix
  ];
}
