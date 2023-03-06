{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.git = {
      enable = mkOptionDefault false;
      gitsigns.enable = mkOptionDefault false;
    };
  };
}
