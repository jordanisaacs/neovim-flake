{ lib, ... }:
with lib; let
  mkEnable = desc:
    mkOption {
      description = "Turn on ${desc} for enabled languages by default";
      type = types.bool;
      default = false;
    };
in
{
  imports = [
    ./bash.nix
    ./clang.nix
    ./cmake.nix
    ./go.nix
    ./html.nix
    ./java.nix
    ./kotlin.nix
    ./markdown.nix
    ./nix.nix
    ./plantuml.nix
    ./python.nix
    ./rust.nix
    ./sclang.nix
    ./sql.nix
    ./terraform.nix
    ./tidal.nix
    ./ts.nix
    ./zig.nix
  ];

  options.vim.languages = {
    enableLSP = mkEnable "LSP";
    enableTreesitter = mkEnable "treesitter";
    enableFormat = mkEnable "formatting";
    enableExtraDiagnostics = mkEnable "extra diagnostics";
    enableDebugger = mkEnable "debuggers";
  };
}
