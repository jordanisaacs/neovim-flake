{
  config,
  pkgs,
  lib,
  ...
}:
let
  l = lib // builtins;
  t = l.types;
  themeSubmodule.options = {
    setup = l.mkOption {
      type = t.str;
      description = "Lua code to initialize theme";
    };
    styles = l.mkOption {
      type = t.nullOr (t.listOf t.str);
      default = null;
    };
  };
in
{
  options.vim.theme = {
    supportedThemes = l.mkOption {
      type = t.attrsOf (t.submodule themeSubmodule);
      description = "Supported themes";
    };
  };

  config.vim.theme.supportedThemes = 
  let
    cfg = config.vim.theme;
    style = cfg.style;
  in
  {
    onedark = 
    let
      defaultStyle = "dark";
    in
    {
      setup = ''
        -- OneDark theme
        require('onedark').setup {
        style = "${if (l.isNull style) then defaultStyle else style}"
        }
        require('onedark').load()
      '';
      styles = [ "dark" "darker" "cool" "deep" "warm" "warmer" ];
    };

    tokyonight = 
    let
      defaultStyle = "night";
    in
    {
      setup = ''
        -- need to set style before colorscheme to apply
        vim.g.tokyonight_style = '${if (l.isNull style) then defaultStyle else style}'
        vim.cmd[[colorscheme tokyonight]]
      '';
      styles = [ "day" "night" "storm" ];
    };

    catppuccin = 
    let
      defaultStyle = "mocha";
    in
      {
      setup = ''
        -- Catppuccin theme
        require('catppuccin').setup {
        flavour = "${if (l.isNull style) then defaultStyle else style}"
        }
        -- setup must be called before loading
        vim.cmd.colorscheme "catppuccin"
      '';
      styles = [ "latte" "frappe" "macchiato" "mocha" ];
    };

    dracula-mofiqul = {
      setup = ''
        require('dracula').setup({});
        require('dracula').load();
      '';
    };

    dracula = {
      setup = ''
        vim.cmd[[colorscheme dracula]]
      '';
    };
  };
}
