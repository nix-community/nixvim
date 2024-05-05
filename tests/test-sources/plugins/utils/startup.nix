{
  empty = {
    plugins.startup.enable = true;
  };

  builtin-theme = {
    plugins.startup = {
      enable = true;
      theme = "dashboard";

      # Default options
      options = {
        mappingKeys = true;
        cursorColumn = 0.5;
        after = null;
        emptyLinesBetweenMappings = true;
        disableStatuslines = true;
        paddings = [];
      };
      mappings = {
        executeCommand = "<CR>";
        openFile = "o";
        openFileSplit = "<c-o>";
        openSection = "<TAB>";
        openHelp = "?";
      };
      colors = {
        background = "#1f2227";
        foldedSection = "#56b6c2";
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

      sections = {
        header = {
          type = "text";
          align = "center";
          foldSection = false;
          title = "Header";
          margin = 5;
          content.__raw = "require('startup.headers').hydra_header";
          highlight = "Statement";
          defaultColor = "";
          oldfilesAmount = 0;
        };
        header_2 = {
          type = "text";
          oldfilesDirectory = false;
          align = "center";
          foldSection = false;
          title = "Quote";
          margin = 5;
          content.__raw = "require('startup.functions').quote()";
          highlight = "Constant";
          defaultColor = "";
          oldfilesAmount = 0;
        };
        body = {
          type = "mapping";
          align = "center";
          foldSection = true;
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
          defaultColor = "";
          oldfilesAmount = 0;
        };
        body_2 = {
          type = "oldfiles";
          oldfilesDirectory = true;
          align = "center";
          foldSection = true;
          title = "Oldfiles of Directory";
          margin = 5;
          content = [];
          highlight = "String";
          defaultColor = "#FFFFFF";
          oldfilesAmount = 5;
        };
        footer = {
          type = "oldfiles";
          oldfilesDirectory = false;
          align = "center";
          foldSection = true;
          title = "Oldfiles";
          margin = 5;
          content = ["startup.nvim"];
          highlight = "TSString";
          defaultColor = "#FFFFFF";
          oldfilesAmount = 5;
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
          oldfilesDirectory = false;
          align = "center";
          foldSection = false;
          title = "";
          margin = 5;
          highlight = "TSString";
          defaultColor = "#FFFFFF";
          oldfilesAmount = 10;
        };
        footer_2 = {
          type = "text";
          content.__raw = "require('startup.functions').packer_plugins()";
          oldfilesDirectory = false;
          align = "center";
          foldSection = false;
          title = "";
          margin = 5;
          highlight = "TSString";
          defaultColor = "#FFFFFF";
          oldfilesAmount = 10;
        };
      };
      options = {
        after = ''
          function()
            require("startup.utils").oldfiles_mappings()
          end
        '';
        mappingKeys = true;
        cursorColumn = 0.5;
        emptyLinesBetweenMappings = true;
        disableStatuslines = true;
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
        foldedSection = "#56b6c2";
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
}
