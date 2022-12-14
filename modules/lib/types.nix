{
  lib,
  extraPluginNames,
}: let
  typesDag = import ./types-dag.nix {inherit lib;};
  typesPlugin = import ./types-plugin.nix {inherit lib extraPluginNames;};
in {
  inherit (typesDag) dagOf;
  inherit (typesPlugin) pluginsOpt;
}
