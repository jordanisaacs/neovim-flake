{
  onedark = {
    setup = { style ? "dark" }: ''
      -- OneDark theme
      require('onedark').setup {
        style = "${style}"
      }
      require('onedark').load()
    '';
    styles = [ "dark" "darker" "cool" "deep" "warm" "warmer" ];
  };

  tokyonight = {
    setup = { style ? "night" }: ''
      -- need to set style before colorscheme to apply
      vim.g.tokyonight_style = '${style}'
      vim.cmd[[colorscheme tokyonight]]
    '';
    styles = [ "day" "night" "storm" ];
  };
}
