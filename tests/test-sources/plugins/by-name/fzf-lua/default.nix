{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.fzf-lua.enable = true;
  };

  example = {
    plugins.web-devicons.enable = true;
    plugins.fzf-lua = {
      enable = true;

      profile = "telescope";
      keymaps = {
        "<Leader>ff" = {
          action = "files";
          settings = {
            cwd = "~/Github";
            winopts = {
              height = 0.1;
              width = 0.5;
            };
          };
          options.silent = true;
        };
        "<Leader>fg" = "live_grep";
        "<C-x><C-f>" = {
          mode = "i";
          action = "complete_file";
          settings = {
            cmd = "rg --files";
            winopts.preview.hidden = "nohidden";
          };
          options = {
            silent = true;
            desc = "Fuzzy complete file";
          };
        };
      };
      settings = {
        grep = {
          prompt = "Grep  ";
        };
        winopts = {
          height = 0.4;
          width = 0.93;
          row = 0.99;
          col = 0.3;
        };
        files = {
          find_opts.__raw = "[[-type f -not -path '*.git/objects*' -not -path '*.env*']]";
          prompt = "Files❯ ";
          multiprocess = true;
          file_icons = true;
          color_icons = true;
        };
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = true;
    plugins.fzf-lua = {
      enable = true;
    };
  };
}
