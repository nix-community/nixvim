{
  empty = {
    plugins.guess-indent.enable = true;
  };

  defaults = {
    plugins.guess-indent = {
      enable = true;

      settings = {
        auto_cmd = true;
        override_editorconfig = false;
        filetype_exclude = [
          "netrw"
          "tutor"
        ];
        buftype_exclude = [
          "help"
          "nofile"
          "terminal"
          "prompt"
        ];
        on_tab_options = {
          "expandtab" = false;
        };
        on_space_options = {
          "expandtab" = true;
          "tabstop" = "detected";
          "softtabstop" = "detected";
          "shiftwidth" = "detected";
        };
      };
    };
  };

  example = {
    plugins.guess-indent = {
      enable = true;

      settings = {
        auto_cmd = false;
        override_editorconfig = true;
        filetype_exclude = [ "markdown" ];
      };
    };
  };
}
