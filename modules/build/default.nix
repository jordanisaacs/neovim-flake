{
  config,
  lib,
  pkgs,
  currentModules,
  ...
}:
with lib;
with builtins; let
  cfgBuild = config.build;
  cfgBuilt = config.built;
  cfgVim = config.vim;

  inputsSubmodule = {...}: {
    options.src = mkOption {
      description = "The plugin source";
      type = types.package;
    };
  };
in {
  options = {
    assertions = lib.mkOption {
      type = types.listOf types.unspecified;
      internal = true;
      default = [];
      example = [
        {
          assertion = false;
          message = "you can't enable this for that reason";
        }
      ];
    };

    warnings = mkOption {
      internal = true;
      default = [];
      type = types.listOf types.str;
      example = ["The `foo' service is deprecated and will go away soon!"];
      description = lib.mdDoc ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };

    build = {
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

      rawPlugins = mkOption {
        description = "Plugins that are just the source, usually from a flake input";
        type = with types; attrsOf (submodule inputsSubmodule);
        default = {};
      };

      package = mkOption {
        description = "Neovim to use for neovim-flake";
        type = types.package;
        default = pkgs.neovim-unwrapped;
      };
    };

    built = {
      configRC = mkOption {
        description = "The final built config";
        type = types.lines;
        readOnly = true;
      };

      startPlugins = mkOption {
        description = "The final built start plugins";
        type = with types; listOf package;
        readOnly = true;
      };

      optPlugins = mkOption {
        description = "The final built opt plugins";
        type = with types; listOf package;
        readOnly = true;
      };

      package = mkOption {
        description = "The final wrapped and configured neovim package";
        type = types.package;
        readOnly = true;
      };
    };
  };

  config = let
    buildPlug = name:
      pkgs.vimUtils.buildVimPluginFrom2Nix rec {
        pname = name;
        version = "master";
        src = assert asserts.assertMsg (name != "nvim-treesitter") "Use buildTreesitterPlug for building nvim-treesitter.";
          cfgBuild.rawPlugins.${pname}.src;
      };

    treeSitterPlug = pkgs.vimPlugins.nvim-treesitter.withPlugins (_: config.vim.treesitter.grammars);

    buildConfigPlugins = plugins:
      map
      (plug: (
        if isString plug
        then
          (
            if (plug == "nvim-treesitter")
            then treeSitterPlug
            else buildPlug plug
          )
        else plug
      ))
      (filter
        (f: f != null)
        plugins);

    normalizedPlugins =
      cfgBuilt.startPlugins
      ++ (map (plugin: {
          inherit plugin;
          optional = true;
        })
        cfgBuilt.optPlugins);

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit (cfgBuild) viAlias vimAlias;
      plugins = normalizedPlugins;
      customRC = cfgBuilt.configRC;
    };

    failedAssertions = map (x: x.message) (filter (x: !x.assertion) config.assertions);

    baseSystemAssertWarn =
      if failedAssertions != []
      then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
      else lib.showWarnings config.warnings;
  in {
    built = baseSystemAssertWarn {
      configRC = let
        mkSection = r: ''
          " SECTION: ${r.name}
          ${r.data}
        '';
        mapResult = r: (concatStringsSep "\n" (map mkSection r));
        vimConfig = nvim.dag.resolveDag {
          name = "vim config script";
          dag = cfgVim.configRC;
          inherit mapResult;
        };
      in
        vimConfig;

      startPlugins = buildConfigPlugins cfgVim.startPlugins;
      optPlugins = buildConfigPlugins cfgVim.optPlugins;

      package =
        (pkgs.wrapNeovimUnstable cfgBuild.package (neovimConfig
          // {
            wrapRc = true;
          }))
        .overrideAttrs (oldAttrs: {
          passthru =
            oldAttrs
            // {
              extendConfiguration = {
                modules ? [],
                pkgs ? config._module.args.pkgs,
                lib ? pkgs.lib,
                extraSpecialArgs ? {},
                check ? config._module.args.check,
              }:
                import ../../modules {
                  modules = currentModules ++ modules;
                  extraSpecialArgs = config._module.specialArgs // extraSpecialArgs;
                  inherit pkgs lib;
                };
            };
          meta =
            oldAttrs.meta
            // {
              module = {
                inherit config options;
              };
            };
        });
    };
  };
}
