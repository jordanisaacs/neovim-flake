{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.theme = {
      enable = mkOptionDefault false;
      name = mkOptionDefault "onedark";
      style = mkOptionDefault "darker";
      extraConfig = mkOptionDefault "";
    };
  };
}
