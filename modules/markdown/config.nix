{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.markdown = {
      enable = mkOptionDefault false;
      glow.enable = mkOptionDefault false;
    };
  };
}
