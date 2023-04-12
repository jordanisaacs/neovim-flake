{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
  usingNvimCmp = config.vim.autocomplete.enable && config.vim.autocomplete.type == "nvim-cmp";
in {
  imports = [
    ./lspconfig.nix
    ./null-ls.nix

    ./lspkind.nix
    ./lspsaga.nix
    ./nvim-code-action-menu.nix
    ./trouble.nix
    ./lsp-signature.nix
    ./lightbulb.nix
    ./fidget.nix
  ];

  options.vim.lsp = {
    enable = mkEnableOption "LSP, also enabled automatically through null-ls and lspconfig options";
    formatOnSave = mkEnableOption "format on save";

    keymap = nvim.keymap.mkKeymapOptions;
  };

  config = let 
    mkSpecialAction = nvim.keymap.mkAction "lsp";
    actions = {
      gotoDeclaration = mkSpecialAction "<cmd>lua vim.lsp.buf.declaration()<CR>";
      gotoDefinition = mkSpecialAction "<cmd>lua vim.lsp.buf.definition()<CR>";
      gotoTypeDefinition = mkSpecialAction "<cmd>lua vim.lsp.buf.type_definition()<CR>";
      nextDiagnostic = mkSpecialAction "<cmd>lua vim.diagnostic.goto_next()<CR>";
      prevDiagnositc = mkSpecialAction "<cmd>lua vim.diagnostic.goto_prev()<CR>";

      addWorkspaceFolder = mkSpecialAction "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>";
      removeWorkspaceFolder = mkSpecialAction "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>";
      listWorkspaceFolder = mkSpecialAction "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>";

      hover = mkSpecialAction "<cmd>lua vim.lsp.buf.hover()<CR>";
      signatureHelp = mkSpecialAction "<cmd>lua vim.lsp.buf.signature_help()<CR>";
      rename = mkSpecialAction "<cmd>lua vim.lsp.buf.rename()<CR>";
    };

    atoms = nvim.keymap.keymappingsOfType "lsp" config.nvim-flake.keymappings;

    keymapString = let
      makeString = mode: binding: action: "vim.api.nvim_buf_set_keymap(bufnr, '${nvim.keymap.modeChar mode}', '${binding}', '${action}', {noremap=true, silent=true})";
      # makeStrings = mode: mapping: (mapAttrsToList (makeString mode) (nvim.keymap.buildKeymapOf "lsp" mapping actions));
    in
      strings.concatStringsSep "\n" (
        map (atom: makeString atom.mode atom.binding atom.action) atoms
      );


   #defaultKeymap = ''
   #    local opts = { noremap=true, silent=true }

   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
   #    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
   #'';
  in 
  mkIf cfg.enable {
    vim.startPlugins = optional usingNvimCmp "cmp-nvim-lsp";

    vim.autocomplete.sources = {"nvim_lsp" = "[LSP]";};

    vim.luaConfigRC.lsp-setup = ''
      vim.g.formatsave = ${boolToString cfg.formatOnSave};

      local attach_keymaps = function(client, bufnr)
        ${traceVal keymapString}
      end

      -- Enable formatting
      format_callback = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            if vim.g.formatsave then
              if client.supports_method("textDocument/formatting") then
                local params = require'vim.lsp.util'.make_formatting_params({})
                client.request('textDocument/formatting', params, nil, bufnr)
              end
            end
          end
        })
      end

      default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
        format_callback(client, bufnr)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      ${optionalString usingNvimCmp "capabilities = require('cmp_nvim_lsp').default_capabilities()"}
    '';
  };
}
