{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./theme.nix
    ./config.nix
    ./supported_themes.nix
  ];
}
