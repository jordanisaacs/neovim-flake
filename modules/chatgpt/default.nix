{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.chatgpt;
in {
  options.vim.chatgpt = {
    enable = mkEnableOption "Enable ChatGPT.nvim";
    config = mkOption {
      description = "ChatGPT.nvim configuration see:
      https://github.com/jackMort/ChatGPT.nvim#configuration";
      type = with types;
        nullOr lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["nui-nvim" "chatgpt-nvim"];
    vim.luaConfigRC.chatgptnvim = nvim.dag.entryAnywhere /* lua */ ''
      require'chatgpt'.setup({ ${cfg.config} })
    '';
  };
}
