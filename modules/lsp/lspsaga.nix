{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    lspsaga = mkEnableOption "Enable LSP Saga";
  };

  config = mkIf (cfg.enable && cfg.lspsaga) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      lspsaga
    ];

    vim.vnoremap = {
      "<silent><leader>ca" = ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>";
    };

    vim.nnoremap = {
      "<silent>gh" = "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>";
      "<silent><leader>ca" = "<cmd>lua require('lspsaga.codeaction').code_action()<CR>";
      "<silent>K" = "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>";
      "<silent><C-f>" = "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>";
      "<silent><C-b>" = "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>";
      "<silent>gs" = "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>";
      "<silent>gr" = "<cmd>lua require('lspsaga.rename').rename()<CR>";
      "<silent>gd" = "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>";
      "<silent><leader>cd" = "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>";
      "<silent><leader>cc" = "<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>";
      "<silent><leader>[e" = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>";
      "<silent><leader>]e" = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>";
    };

    vim.luaConfigRC = ''
      -- Enable lspsaga
      local saga = require 'lspsaga'
      saga.init_lsp_saga()
    '';
  };
}
