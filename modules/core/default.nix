{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim;

  wrapLuaConfig = luaConfig: ''
    lua << EOF
    ${luaConfig}
    EOF
  '';

  mkMappingOption = it:
    mkOption ({
        default = {};
        type = with types; attrsOf (nullOr str);
      }
      // it);
in {
  options.vim = {
    viAlias = mkOption {
      description = "Enable vi alias";
      type = types.bool;
      default = true;
    };

    vimAlias = mkOption {
      description = "Enable vim alias";
      type = types.bool;
      default = true;
    };

    configRC = mkOption {
      description = "vimrc contents";
      type = types.lines;
      default = "";
    };

    startLuaConfigRC = mkOption {
      description = "start of vim lua config";
      type = types.lines;
      default = "";
    };

    luaConfigRC = mkOption {
      description = "vim lua config";
      type = types.lines;
      default = "";
    };

    startPlugins = mkOption {
      description = "List of plugins to startup";
      default = [];
      type = with types; listOf (nullOr package);
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [];
      type = with types; listOf package;
    };

    globals = mkOption {
      default = {};
      description = "Set containing global variable values";
      type = types.attrs;
    };

    nnoremap =
      mkMappingOption {description = "Defines 'Normal mode' mappings";};

    inoremap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vnoremap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    xnoremap =
      mkMappingOption {description = "Defines 'Visual mode' mappings";};

    snoremap =
      mkMappingOption {description = "Defines 'Select mode' mappings";};

    cnoremap =
      mkMappingOption {description = "Defines 'Command-line mode' mappings";};

    onoremap = mkMappingOption {
      description = "Defines 'Operator pending mode' mappings";
    };

    tnoremap =
      mkMappingOption {description = "Defines 'Terminal mode' mappings";};

    nmap = mkMappingOption {description = "Defines 'Normal mode' mappings";};

    imap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vmap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    xmap = mkMappingOption {description = "Defines 'Visual mode' mappings";};

    smap = mkMappingOption {description = "Defines 'Select mode' mappings";};

    cmap =
      mkMappingOption {description = "Defines 'Command-line mode' mappings";};

    omap = mkMappingOption {
      description = "Defines 'Operator pending mode' mappings";
    };

    tmap =
      mkMappingOption {description = "Defines 'Terminal mode' mappings";};
  };

  config = let
    filterNonNull = mappings: filterAttrs (name: value: value != null) mappings;
    globalsScript =
      mapAttrsFlatten (name: value: "let g:${name}=${toJSON value}")
      (filterNonNull cfg.globals);

    matchCtrl = it: match "Ctrl-(.)(.*)" it;
    mapKeyBinding = it: let
      groups = matchCtrl it;
    in
      if groups == null
      then it
      else "<C-${toUpper (head groups)}>${head (tail groups)}";
    mapVimBinding = prefix: mappings:
      mapAttrsFlatten (name: value: "${prefix} ${mapKeyBinding name} ${value}")
      (filterNonNull mappings);

    nmap = mapVimBinding "nmap" config.vim.nmap;
    imap = mapVimBinding "imap" config.vim.imap;
    vmap = mapVimBinding "vmap" config.vim.vmap;
    xmap = mapVimBinding "xmap" config.vim.xmap;
    smap = mapVimBinding "smap" config.vim.smap;
    cmap = mapVimBinding "cmap" config.vim.cmap;
    omap = mapVimBinding "omap" config.vim.omap;
    tmap = mapVimBinding "tmap" config.vim.tmap;

    nnoremap = mapVimBinding "nnoremap" config.vim.nnoremap;
    inoremap = mapVimBinding "inoremap" config.vim.inoremap;
    vnoremap = mapVimBinding "vnoremap" config.vim.vnoremap;
    xnoremap = mapVimBinding "xnoremap" config.vim.xnoremap;
    snoremap = mapVimBinding "snoremap" config.vim.snoremap;
    cnoremap = mapVimBinding "cnoremap" config.vim.cnoremap;
    onoremap = mapVimBinding "onoremap" config.vim.onoremap;
    tnoremap = mapVimBinding "tnoremap" config.vim.tnoremap;
  in {
    vim.configRC = ''
      ${concatStringsSep "\n" globalsScript}
      " Lua config from vim.luaConfigRC
      ${wrapLuaConfig
        (concatStringsSep "\n" [cfg.startLuaConfigRC cfg.luaConfigRC])}
        ${builtins.concatStringsSep "\n" nmap}
        ${builtins.concatStringsSep "\n" imap}
        ${builtins.concatStringsSep "\n" vmap}
        ${builtins.concatStringsSep "\n" xmap}
        ${builtins.concatStringsSep "\n" smap}
        ${builtins.concatStringsSep "\n" cmap}
        ${builtins.concatStringsSep "\n" omap}
        ${builtins.concatStringsSep "\n" tmap}
        ${builtins.concatStringsSep "\n" nnoremap}
        ${builtins.concatStringsSep "\n" inoremap}
        ${builtins.concatStringsSep "\n" vnoremap}
        ${builtins.concatStringsSep "\n" xnoremap}
        ${builtins.concatStringsSep "\n" snoremap}
        ${builtins.concatStringsSep "\n" cnoremap}
        ${builtins.concatStringsSep "\n" onoremap}
        ${builtins.concatStringsSep "\n" tnoremap}
    '';
  };
}
