{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.telescope;
in
{
  options.vim.telescope = {
    enable = mkEnableOption "enable telescope";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      telescope
    ];

    vim.nnoremap = {
      "<leader>ff" = "<cmd> Telescope find_files<CR>";
      "<leader>fg" = "<cmd> Telescope live_grep<CR>";
      "<leader>fb" = "<cmd> Telescope buffers<CR>";
      "<leader>fh" = "<cmd> Telescope help_tags<CR>";
      "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
      "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
      "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
      "<leader>fvs" = "<cmd> Telescope git_status<CR>";
      "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
      "<leader>ft" = "<cmd> Telescope<CR>";
    } // (if config.vim.lsp.enable then {
      "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
      "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";
      "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
      "<leader>flc" = "<cmd> Telescope lsp_code_actions<CR>";
      "<leader>fld" = "<cmd> Telescope lsp_definitions<CR>";
      "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
      "<leader>fldb" = "<cmd> Telescope lsp_document_diagnostics<CR>";
      "<leader>fldw" = "<cmd> Telescope lsp_workspace_diagnostics<CR>";
    } else { }) // (if config.vim.treesitter.enable then {
      "<leader>fs" = "<cmd> Telescope treesitter";
    } else { });
  };
}
