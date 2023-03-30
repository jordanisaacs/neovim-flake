{lib}:
with lib; let
  pluginsType = rawPlugins:
    with types;
      listOf (nullOr (either
        (enum ((attrNames rawPlugins) ++ ["nvim-treesitter"]))
        package));
in {
  pluginsOpt = {
    rawPlugins,
    description,
    default ? [],
  }:
    mkOption {
      inherit description default;
      type = pluginsType rawPlugins;
    };
}
