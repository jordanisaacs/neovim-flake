{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.nvim-flake;
in {
  options.vim.keymap = nvim.keymap.mkKeymapOptions;
  options.nvim-flake.keymapActions = mkOption {
    type = types.attrsOf types.anything;
    default = {};
  };
  options.nvim-flake.keymappings = mkOption {
    type = types.attrsOf types.anything;
    default = {};
  };

  config = let
    actions =
      cfg.keymapActions
      // {
        executeViml = viml: lib.nvim.keymap.mkVimAction viml;
      };
    keymap = config.vim.keymap;

    keymapping = groupBy (atom: atom.type) (
      flatten (
        mapAttrsToList (
          mode: mappingsInMode:
            mapAttrsToList (binding: action: {
              inherit mode;
              inherit binding;
              inherit (action) action type;
            })
            (mappingsInMode actions)
        )
        keymap
      )
    );
  in {
    vim.nnoremap = let nmappings = nvim.keymap.buildKeymap keymap.normal actions; in traceSeq nmappings nmappings;
    vim.vnoremap = nvim.keymap.buildKeymap keymap.visual actions;
    vim.snoremap = nvim.keymap.buildKeymap keymap.select actions;
    vim.inoremap = nvim.keymap.buildKeymap keymap.insert actions;
    vim.cnoremap = nvim.keymap.buildKeymap keymap.command actions;
    vim.tnoremap = nvim.keymap.buildKeymap keymap.terminal actions;
    vim.onoremap = nvim.keymap.buildKeymap keymap.operatorPending actions;

    nvim-flake.keymappings = traceSeq {keymapping = keymapping;} keymapping;
  };
}
