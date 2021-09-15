{ inputs, plugins, ... }:
final: prev:
let
  inherit (prev.vimUtils) buildVimPluginFrom2Nix;

  treesitterGrammars = prev.tree-sitter.withPlugins (_: prev.tree-sitter.allGrammars);
  
  buildPlug = name: buildVimPluginFrom2Nix {
    pname = name;
    version = "master";
    src = builtins.getAttr name inputs;
    postPatch = if (name == "nvim-treesitter") then ''
      rm -r parser
      ln -s ${treesitterGrammars} parser
    '' else "";
  };
in
{
  neovimPlugins = builtins.listToAttrs
    (map (name: { inherit name; value = buildPlug name; }) plugins);
}
