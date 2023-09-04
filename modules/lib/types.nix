{ lib }:
let
  typesDag = import ./types-dag.nix { inherit lib; };
in
{
  inherit (typesDag) dagOf;
}
