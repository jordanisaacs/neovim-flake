{lib, ...}:
with lib; let
  mkEnable = desc:
    mkOption {
      description = "Turn on ${desc} for enabled languages by default";
      type = types.bool;
      default = false;
    };
in {
  imports = [
    ./clang.nix
    ./go.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./sql.nix
    ./ts.nix
    ./zig.nix
    ./markdown.nix
    ./plantuml.nix
    ./tidal.nix
    ./html.nix
  ];

  options.vim.languages = {
    enableLSP = mkEnable "LSP";
    enableTreesitter = mkEnable "treesitter";
    enableFormat = mkEnable "formatting";
    enableExtraDiagnostics = mkEnable "extra diagnostics";
  };
}
