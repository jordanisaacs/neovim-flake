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
    select = mkOption {
      type = types.functionTo types.anything;
      default = _: {};
    };
    insert = mkOption {
      type = types.functionTo types.anything;
      default = _: {};
    };
    command = mkOption {
      type = types.functionTo types.anything;
      default = _: {};
    };
    terminal = mkOption {
      type = types.functionTo types.anything;
      default = _: {};
    };
    operatorPending = mkOption {
      type = types.functionTo types.anything;
      default = _: {};
    };
  };

  mkAction = type: action: {
    inherit action;
    inherit type;
  };

  mkVimAction = action: lib.nvim.keymap.mkAction "vim" action;

  # mapping is a function: Actions -> AttrSet(keybind -> action)
  # actions is an Actions AttrSet
  # an Actions attrset looks like
  # {
  #   "NameOfAction": {
  #     type = "actionType";
  #   }
  # }

  buildKeymap = lib.nvim.keymap.buildKeymapOf "vim";
  buildKeymapOf = actionType: mappingFn: actions: let
    mapping = mappingFn (actions
      // {
        executeViml = viml: lib.nvim.keymap.mkVimAction viml;
      });
  in
    lib.mapAttrs (_: v: v.action) (lib.filterAttrs (_: v: v.type == actionType) mapping);

  modeChar = mode:
    {
      "normal" = "n";
      "insert" = "i";
      "visual" = "v";
      "command" = "c";
      "operatorPending" = "o";
      "terminal" = "t";
      "select" = "s";
    }
    .${mode};

  keymappingsOfType = type: atoms:
    if hasAttr type atoms
    then getAttr type atoms
    else [];
}
