{
  empty = { };

  example = {
    plugins.tagbar = {
      enable = true;

      settings = {
        position = "right";
        autoclose = false;
        autofocus = false;
        foldlevel = 2;
        autoshowtag = true;
        iconchars = [
          ""
          ""
        ];
        wrap = true;
        show_data_type = true;
        show_visibility = true;
        visibility_symbols = {
          public = "󰡭 ";
          protected = "󱗤 ";
          private = "󰛑 ";
        };
        show_linenumbers = true;
        case_insensitive = true;
        show_tag_count = true;
        compact = true;
        indent = true;
        autopreview = false;
        previewwin_pos = "belowleft";
        scopestrs = {
          class = "\\uf0e8";
          struct = "\\uf0e8";
          const = "\\uf8ff";
          constant = "\\uf8ff";
          enum = "\\uf702";
          field = "\\uf30b";
          func = "\\uf794";
          function = "\\uf794";
          getter = "\\ufab6";
          implementation = "\\uf776";
          interface = "\\uf7fe";
          map = "\\ufb44";
          member = "\\uf02b";
          method = "\\uf6a6";
          setter = "\\uf7a9";
          variable = "\\uf71b";
        };
      };
    };
  };

  no-packages = {
    plugins.tagbar.enable = true;

    dependencies.ctags.enable = false;
  };
}
