{lib}: let
  typesDag = import ./types-dag.nix {inherit lib;};
  typesPlugin = import ./types-plugin.nix {inherit lib;};
  typesLanguage = import ./types-languages.nix {inherit lib;};
in {
  inherit (typesDag) dagOf;
  inherit (typesPlugin) pluginsOpt;
  inherit (typesLanguage) diagnostics mkGrammarOption;
}
