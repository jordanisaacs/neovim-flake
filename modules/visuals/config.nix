{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.visuals = {
      enable = mkOptionDefault false;

      nvimWebDevicons.enable = mkOptionDefault false;
      lspkind.enable = mkOptionDefault false;

      cursorWordline = {
        enable = mkOptionDefault false;
        lineTimeout = mkOptionDefault 500;
      };

      indentBlankline = {
        enable = mkOptionDefault false;
        listChar = mkOptionDefault "│";
        fillChar = mkOptionDefault "⋅";
        eolChar = mkOptionDefault "↴";
        showCurrContext = mkOptionDefault true;
      };
    };
  };
}
