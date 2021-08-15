{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.tabline.nvimBufferline;
in {
  options.vim.tabline.nvimBufferline = {
    enable = mkEnableOption "nvim-bufferline-lua";
  };

  config = mkIf cfg.enable (
    let
      mouse = {
        right = "'verical sbuffer %d'";
        close = ''
          function(bufnum)
            require("bufdelete").bufdelete(bufnum, false)
          end
        '';
      };
    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        (assert config.vim.icons.nvimWebDevicons == true; nvim-bufferline-lua)
        bufdelete-nvim
      ];

      vim.nnoremap = {
        "<silent>[b" = ":BufferLineCycleNext<CR>";
        "<silent>b]" = ":BufferLineCyclePrev<CR>";
        "<silent>bse" = ":BufferLineSortByExtension<CR>";
        "<silent>bsd" = ":BufferLineSortByDirectory<CR>";
        "<silent>bsi" = ":lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>";
        "<silent>bmn" = ":BufferLineMoveNext<CR>";
        "<silent>bmp" = ":BufferLineMovePrev<CR>";
      };

      vim.luaConfigRC = ''
        require("bufferline").setup{
           options = {
              numbers = "both",
              number_style = { "none", "subscript" },
              mappings = true,
              close_command = ${mouse.close},
              right_mouse_command = ${mouse.right},
              indicator_icon = '▎',
              buffer_close_icon = '',
              modified_icon = '●',
              close_icon = '',
              left_trunc_marker = '',
              right_trunc_marker = '',
              separator_style = "thin",
              max_name_length = 18,
              max_prefix_length = 15,
              tab_size = 18,
              show_buffer_icons = true,
              show_buffer_close_icons = true,
              show_close_icon = true,
              show_tab_indicators = true,
              persist_buffer_sort = true,
              enforce_regular_tabs = true,
              always_show_bufferline = true,
              offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
              sort_by = 'extension',
              diagnostics = "nvim_lsp",
              diagnostics_indicator = function(count, level, diagnostics_dict, context)
                 local s = ""
                 for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and ""
                       or (e == "warning" and "" or "" )
                    if(sym ~= "") then
                    s = s .. " " .. n .. sym
                    end
                 end
                 return s
              end,
           }
        }
      '';
    }
  );
}
