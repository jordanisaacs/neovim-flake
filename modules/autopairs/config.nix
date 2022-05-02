{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.autopairs = {
      enable = mkDefault false;
      type = mkDefault "nvim-autopairs";
    };
  };
}
