{ lib }:
let
  optionsPlugin = import ./options-plugin.nix { inherit lib; };
  optionsLanguage = import ./options-languages.nix { inherit lib; };
in
{
  inherit (optionsPlugin) mkPluginsOption;
  inherit (optionsLanguage) mkDiagnosticsOption mkGrammarOption mkCommandOption;
}
