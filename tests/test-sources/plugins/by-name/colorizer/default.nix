{
  empty = {
    plugins.colorizer.enable = true;
  };

  defaults = {
    plugins.colorizer = {
      enable = true;

      settings = {
        filetypes.__empty = { };
        user_default_options = {
          RGB = true;
          RRGGBB = true;
          names = true;
          RRGGBBAA = false;
          AARRGGBB = false;
          rgb_fn = false;
          hsl_fn = false;
          css = false;
          css_fn = false;
          mode = "background";
          tailwind = false;
          sass = {
            enable = false;
            parsers = [ "css" ];
          };
          virtualtext = "■";
          virtualtext_inline = false;
          virtualtext_mode = "foreground";
          always_update = false;
        };
        buftypes.__empty = { };
        user_commands = true;
      };
    };
  };

  example = {
    plugins.colorizer = {
      enable = true;

      settings = {
        filetypes = {
          __unkeyed-1 = "*";
          __unkeyed-2 = "!vim";
          css.rgb_fn = true;
          html.names = false;
        };
        user_default_options = {
          mode = "virtualtext";
          names = false;
          virtualtext = "■ ";
        };
        user_commands = [
          "ColorizerToggle"
          "ColorizerReloadAllBuffers"
        ];
      };
    };
  };
}
