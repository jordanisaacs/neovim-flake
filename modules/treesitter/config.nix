{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.treesitter = {
      enable = mkDefault false;
      fold = mkDefault true;
      autotagHtml = mkDefault false;
      context.enable = mkDefault false;
    };
  };
}
