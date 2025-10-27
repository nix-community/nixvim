{
  empty = {
    plugins.startup.enable = true;
  };

  builtin-theme = {
    plugins.startup = {
      enable = true;
      settings = {
        theme = "dashboard";

        # Default options
        options = {
          mapping_keys = true;
          cursor_column = 0.5;
          after.__raw = "nil";
          empty_lines_between_mappings = true;
          disable_statuslines = true;
          paddings.__empty = { };
        };
        mappings = {
          execute_command = "<CR>";
          open_file = "o";
          open_file_split = "<c-o>";
          open_section = "<TAB>";
          open_help = "?";
        };
        colors = {
          background = "#1f2227";
          folded_section = "#56b6c2";
        };
      };
      userMappings = {
        "<leader>ff" = "<cmd>Telescope find_files<CR>";
        "<leader>lg" = "<cmd>Telescope live_grep<CR>";
      };
    };
  };

  # Replicate the settings of the 'evil' theme
  custom-section-evil = {
    plugins.startup = {
      enable = true;

      settings = {
        header = {
          type = "text";
          align = "center";
          fold_section = false;
          title = "Header";
          margin = 5;
          content.__raw = "require('startup.headers').hydra_header";
          highlight = "Statement";
          default_color = "";
          oldfiles_amount = 0;
        };
        header_2 = {
          type = "text";
          oldfiles_directory = false;
          align = "center";
          fold_section = false;
          title = "Quote";
          margin = 5;
          content.__raw = "require('startup.functions').quote()";
          highlight = "Constant";
          default_color = "";
          oldfiles_amount = 0;
        };
        body = {
          type = "mapping";
          align = "center";
          fold_section = true;
          title = "Basic Commands";
          margin = 5;
          content = [
            [
              " Find File"
              "Telescope find_files"
              "<leader>ff"
            ]
            [
              "󰍉 Find Word"
              "Telescope live_grep"
              "<leader>lg"
            ]
            [
              " Recent Files"
              "Telescope oldfiles"
              "<leader>of"
            ]
            [
              " File Browser"
              "Telescope file_browser"
              "<leader>fb"
            ]
            [
              " Colorschemes"
              "Telescope colorscheme"
              "<leader>cs"
            ]
            [
              " New File"
              "lua require'startup'.new_file()"
              "<leader>nf"
            ]
          ];
          highlight = "String";
          default_color = "";
          oldfiles_amount = 0;
        };
        body_2 = {
          type = "oldfiles";
          oldfiles_directory = true;
          align = "center";
          fold_section = true;
          title = "Oldfiles of Directory";
          margin = 5;
          content.__empty = { };
          highlight = "String";
          default_color = "#FFFFFF";
          oldfiles_amount = 5;
        };
        footer = {
          type = "oldfiles";
          oldfiles_directory = false;
          align = "center";
          fold_section = true;
          title = "Oldfiles";
          margin = 5;
          content = [ "startup.nvim" ];
          highlight = "TSString";
          default_color = "#FFFFFF";
          oldfiles_amount = 5;
        };
        clock = {
          type = "text";
          content.__raw = ''
            function()
              local clock = " " .. os.date("%H:%M")
              local date = " " .. os.date("%d-%m-%y")
              return { clock, date }
            end
          '';
          oldfiles_directory = false;
          align = "center";
          fold_section = false;
          title = "";
          margin = 5;
          highlight = "TSString";
          default_color = "#FFFFFF";
          oldfiles_amount = 10;
        };
        footer_2 = {
          type = "text";
          content.__raw = "require('startup.functions').packer_plugins()";
          oldfiles_directory = false;
          align = "center";
          fold_section = false;
          title = "";
          margin = 5;
          highlight = "TSString";
          default_color = "#FFFFFF";
          oldfiles_amount = 10;
        };
        options = {
          after = ''
            function()
              require("startup.utils").oldfiles_mappings()
            end
          '';
          mapping_keys = true;
          cursor_column = 0.5;
          empty_lines_between_mappings = true;
          disable_statuslines = true;
          paddings = [
            2
            2
            2
            2
            2
            2
            2
          ];
        };
        colors = {
          background = "#1f2227";
          folded_section = "#56b6c2";
        };
        parts = [
          "header"
          "header_2"
          "body"
          "body_2"
          "footer"
          "clock"
          "footer_2"
        ];
      };
    };
  };
}
