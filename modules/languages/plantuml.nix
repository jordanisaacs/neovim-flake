{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.plantuml;
in {
  options.vim.languages = {
    plantuml = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable plantuml previewer";
      };
      plantumlPackage = mkOption {
        type = types.package;
        default = pkgs.plantuml;
        defaultText = literalExpression "pkgs.plantuml";
        example = literalExpression "pkgs.plantuml";
        description = ''
          Version of plantuml to use.
        '';
      };
      javaPackage = mkOption {
        type = types.package;
        default = pkgs.openjdk;
        defaultText = literalExpression "pkgs.openjdk";
        example = literalExpression "pkgs.openjdk";
        description = ''
          Version of java to use.
        '';
      };
    };
  };

  config =
    mkIf cfg.enable
    {
      vim.startPlugins = [
        "plantuml-previewer"
        "plantuml-syntax"
        "open-browser"
      ];

      vim.configRC.plantuml = nvim.dag.entryAnywhere ''
        au filetype plantuml let g:plantuml_previewer#viewer_path = "/tmp/plantuml"
        au filetype plantuml let g:plantuml_previewer#java_path = "${cfg.javaPackage}/bin/java"
        au filetype plantuml let g:plantuml_previewer#plantuml_jar_path = "${cfg.plantumlPackage}/lib/plantuml.jar"
      '';
    };
}
