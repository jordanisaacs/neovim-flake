{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.telescope;
in
{
  options.vim.telescope = {
    enable = mkEnableOption "telescope";

    fileBrowser = {
      enable = mkEnableOption "telescope file browser";

      hijackNetRW = mkOption {
        default = true;
        description = "Disables netrw and use telescope-file-browser in its place.";
        type = types.bool;
      };
    };

    liveGrepArgs = {
      enable = mkEnableOption "telescope live grep with args";
      autoQuoting = mkOption {
        default = true;
        description = ''If the prompt value does not begin with ', " or - the entire prompt is treated as a single argument.'';
        type = types.bool;

      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.liveGrepArgs.enable {
      vim.startPlugins = [ "telescope-live-grep-args" ];

      vim.nnoremap = {
        "<leader>fa" = "<cmd> Telescope live_grep_args<CR>";
      };

      # Mappings currently broken: https://github.com/nvim-telescope/telescope-live-grep-args.nvim/issues/71
      # mappings = {
      #   i = {
      #     ["<C-k>"] = lga_actions.quote_prompt(),
      #     ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
      #   },
      # },
      vim.luaConfigRC.telescope-live-grep-args-setup = nvim.dag.entryBefore [ "telescope" ] ''
        local lga_actions = require("telescope-live-grep-args.actions")

        require("telescope").setup {
          extensions = {
            live_grep_args = {
              auto_quoting = ${boolToString cfg.liveGrepArgs.autoQuoting},
            }
          }
        }
      '';

      vim.luaConfigRC.telescope-live-grep-args-load = nvim.dag.entryAfter [ "telescope" ] ''
        require("telescope").load_extension "live_grep_args"

      '';

    })
    (mkIf cfg.fileBrowser.enable {
      vim.startPlugins = [ "telescope-file-browser" ];

      vim.nnoremap = {
        "<leader>fd" = "<cmd> Telescope file_browser<CR>";
      };

      vim.luaConfigRC.telescope-file-browser-setup = nvim.dag.entryBefore [ "telescope" ] ''
        require("telescope").setup {
          extensions = {
            file_browser = {
              hijack_netrw = ${boolToString cfg.fileBrowser.hijackNetRW},
            }
          }
        }
      '';

      vim.luaConfigRC.telescope-file-browser-load = nvim.dag.entryAfter [ "telescope" ] ''
        require("telescope").load_extension "file_browser"
      '';
    })
    (mkIf config.vim.treesitter.enable {
      vim.nnoremap = {
        "<leader>fs" = "<cmd> Telescope treesitter<CR>";
      };
    })
    (mkIf config.vim.lsp.enable {
      vim.nnoremap = {
        "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
        "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

        "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
        "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
        "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
        "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
        "<leader>fld" = "<cmd> Telescope diagnostics<CR>";
      };
    })
    {
      vim.startPlugins = [
        "telescope"
      ];

      vim.nnoremap = {
        "<leader>ff" = "<cmd> Telescope find_files<CR>";
        "<leader>fg" = "<cmd> Telescope live_grep<CR>";
        "<leader>fb" = "<cmd> Telescope buffers<CR>";
        "<leader>fh" = "<cmd> Telescope help_tags<CR>";
        "<leader>ft" = "<cmd> Telescope<CR>";

        "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
        "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
        "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
        "<leader>fvs" = "<cmd> Telescope git_status<CR>";
        "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
      };

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
    }
  ]);
}
