{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.statusline.lualine = {
      enable = mkOptionDefault false;

      icons = mkOptionDefault true;
      theme = mkOptionDefault "auto";
      sectionSeparator = {
        left = mkOptionDefault "";
        right = mkOptionDefault "";
      };

      componentSeparator = {
        left = mkOptionDefault "⏽";
        right = mkOptionDefault "⏽";
      };

      activeSection = {
        a = mkOptionDefault "{'mode'}";
        b = ''
          {
            {
              "branch",
              separator = '',
            },
            "diff",
          }
        '';
        c = mkOptionDefault "{'filename'}";
        x = mkOptionDefault ''
          {
            {
              "diagnostics",
              sources = {'nvim_lsp'},
              separator = '',
              symbols = {error = '', warn = '', info = '', hint = ''},
            },
            {
              "filetype",
            },
            "fileformat",
            "encoding",
          }
        '';
        y = mkOptionDefault "{'progress'}";
        z = mkOptionDefault "{'location'}";
      };

      inactiveSection = {
        a = mkOptionDefault "{}";
        b = mkOptionDefault "{}";
        c = mkOptionDefault "{'filename'}";
        x = mkOptionDefault "{'location'}";
        y = mkOptionDefault "{}";
        z = mkOptionDefault "{}";
      };
    };
  };
}
