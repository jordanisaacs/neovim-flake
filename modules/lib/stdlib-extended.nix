# From home-manager: https://github.com/nix-community/home-manager/blob/master/modules/lib/stdlib-extended.nix
# Just a convenience function that returns the given Nixpkgs standard
# library extended with the HM library.
{
  lib,
  extraPluginNames ? [],
}: let
  mkNvimLib = import ./.;
in
  lib.extend (self: super: {
    nvim = mkNvimLib {lib = self;};

    # For forward compatibility.
    literalExpression = super.literalExpression or super.literalExample;
    literalDocBook = super.literalDocBook or super.literalExample;
  })
