{ lib, ... }:
{
  empty = {
    plugins.actions-preview.enable = true;
  };

  defaults = {
    plugins = {
      web-devicons.enable = true;
      telescope.enable = true;

      actions-preview = {
        enable = true;

        settings = {
          diff = {
            ctxlen = 3;
          };
          highlight_command.__empty = { };
          backend = [
            "telescope"
            "minipick"
            "snacks"
            "nui"
          ];
          telescope.__raw = ''
            vim.tbl_extend(
              "force",
              require("telescope.themes").get_dropdown(),
              {
                make_value = nil,
                make_make_display = nil,
              }
            )
          '';
          nui = {
            dir = "col";
            keymap.__raw = "nil";
            layout = {
              position = "50%";
              size = {
                width = "60%";
                height = "90%";
              };
              min_width = 40;
              min_height = 10;
              relative = "editor";
            };
            preview = {
              size = "60%";
              border = {
                style = "rounded";
                padding = [
                  0
                  1
                ];
              };
            };
            select = {
              size = "40%";
              border = {
                style = "rounded";
                padding = [
                  0
                  1
                ];
              };
            };
          };
          snacks = {
            layout.preset = "default";
          };
        };
      };
    };
  };

  example = {
    plugins.actions-preview = {
      enable = true;

      settings = {
        telescope = {
          sorting_strategy = "ascending";
          layout_strategy = "vertical";
          layout_config = {
            width = 0.8;
            height = 0.9;
            prompt_position = "top";
            preview_cutoff = 20;
            preview_height.__raw = ''
              function(_, _, max_lines)
                return max_lines - 15
              end
            '';
          };
        };
        highlight_command = [
          (lib.nixvim.mkRaw "require('actions-preview.highlight').delta 'delta --side-by-side'")
          (lib.nixvim.mkRaw "require('actions-preview.highlight').diff_so_fancy()")
          (lib.nixvim.mkRaw "require('actions-preview.highlight').diff_highlight()")
        ];
      };
    };
  };
}
