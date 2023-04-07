{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.telescope;
in {
  options.vim.telescope = {
    enable = mkEnableOption "enable telescope";

    keymap = nvim.keymap.mkKeymapOptions;
  };

  config = let
    actions = with nvim.keymap;
      {
        findFiles = mkVimAction "<cmd> Telescope find_files<CR>";
        liveGrep = mkVimAction "<cmd> Telescope live_grep<CR>";
        buffers = mkVimAction "<cmd> Telescope buffers<CR>";
        helpTags = mkVimAction "<cmd> Telescope help_tags<CR>";
        open = mkVimAction "<cmd> Telescope<CR>";

        gitCommits = mkVimAction "<cmd> Telescope git_commits<CR>";
        gitBCommits = mkVimAction "<cmd> Telescope git_bcommits<CR>";
        gitBranches = mkVimAction "<cmd> Telescope git_branches<CR>";
        gitStatus = mkVimAction "<cmd> Telescope git_status<CR>";
        gitStash = mkVimAction "<cmd> Telescope git_stash<CR>";
      }
      // (
        if config.vim.lsp.enable
        then {
          lspDocumentSymbols = mkVimAction "<cmd> Telescope lsp_document_symbols<CR>";
          lspWorkspaceSymbols = mkVimAction "<cmd> Telescope lsp_workspace_symbols<CR>";

          lspReferences = mkVimAction "<cmd> Telescope lsp_references<CR>";
          lspImplementations = mkVimAction "<cmd> Telescope lsp_implementations<CR>";
          lspDefinitions = mkVimAction "<cmd> Telescope lsp_definitions<CR>";
          lspTypeDefinitions = mkVimAction "<cmd> Telescope lsp_type_definitions<CR>";
          lspDiagnostics = mkVimAction "<cmd> Telescope diagnostics<CR>";
        }
        else {}
      )
      // (
        if config.vim.treesitter.enable
        then {
          treesitter = mkVimAction "<cmd> Telescope treesitter<CR>";
        }
        else {}
      );
  in
    mkIf (cfg.enable) {
      vim.startPlugins = [
        "telescope"
      ];

      vim.nnoremap = nvim.keymap.buildKeymap cfg.keymap.normal actions;
      vim.vnoremap = nvim.keymap.buildKeymap cfg.keymap.visual actions;
      vim.inoremap = nvim.keymap.buildKeymap cfg.keymap.insert actions;

      #vim.nnoremap =
      #  {
      #    "<leader>ff" = "<cmd> Telescope find_files<CR>";
      #    "<leader>fg" = "<cmd> Telescope live_grep<CR>";
      #    "<leader>fb" = "<cmd> Telescope buffers<CR>";
      #    "<leader>fh" = "<cmd> Telescope help_tags<CR>";
      #    "<leader>ft" = "<cmd> Telescope<CR>";

      #    "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
      #    "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
      #    "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
      #    "<leader>fvs" = "<cmd> Telescope git_status<CR>";
      #    "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
      #  }
      #  // (
      #    if config.vim.lsp.enable
      #    then {
      #      "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
      #      "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

      #      "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
      #      "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
      #      "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
      #      "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
      #      "<leader>fld" = "<cmd> Telescope diagnostics<CR>";
      #    }
      #    else {}
      #  )
      #  // (
      #    if config.vim.treesitter.enable
      #    then {
      #      "<leader>fs" = "<cmd> Telescope treesitter<CR>";
      #    }
      #    else {}
      #  );

      vim.luaConfigRC.telescope = nvim.dag.entryAnywhere ''
        require("telescope").setup {
          defaults = {
            vimgrep_arguments = {
              "${pkgs.ripgrep}/bin/rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case"
            },
            pickers = {
              find_command = {
                "${pkgs.fd}/bin/fd",
              },
            },
          }
        }
      '';
    };
}
