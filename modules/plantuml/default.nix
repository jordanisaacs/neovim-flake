{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.plantuml;
in {
  options.vim = {
    plantuml = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable plantuml previewer";
      };
    };
  };

  config =
    mkIf cfg.enable
    {
      vim.startPlugins = [
        "plantuml-previewer"
        pkgs.vimPlugins.plantuml-syntax
        pkgs.vimPlugins.open-browser
      ];

      vim.configRC.plantuml = nvim.dag.entryAnywhere ''
        au filetype plantuml let g:plantuml_previewer#viewer_path = "/tmp/plantuml"
        au filetype plantuml let g:plantuml_previewer#java_path = "${pkgs.openjdk}/bin/java"
        au filetype plantuml let g:plantuml_previewer#plantuml_jar_path = "${pkgs.plantuml}/lib/plantuml.jar"
      '';
    };
}
