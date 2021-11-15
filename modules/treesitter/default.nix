{ config, lib, pkgs, ... }:
{
  imports = [
    ./treesitter.nix
    ./config.nix
  ];
}
