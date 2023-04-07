{lib}:
with lib; {
  mkKeymapOptions = {
    normal = mkOption {
      type = types.functionTo types.anything;
      default = _: {};
    };
    visual = mkOption {
      type = types.functionTo types.anything;
      default = _: {};
    };
    insert = mkOption {
      type = types.functionTo types.anything;
      default = _: {};
    };
  };

  mkVimAction = action: {
    inherit action;
    type = "vim";
  };

  # mapping is a function: Actions -> AttrSet(keybind -> action)
  # actions is an Actions AttrSet
  # an Actions attrset looks like
  # {
  #   "NameOfAction": {
  #     type = "actionType";
  #   }
  # }
  buildKeymap = mappingFn: actions: let
    mapping = mappingFn (actions
      // {
        executeViml = viml: lib.nvim.keymap.mkVimAction viml;
      });
  in
    lib.mapAttrs (_: v: v.action) (lib.filterAttrs (_: v: v.type == "vim") mapping);
}
