{
  empty = {
    plugins.neotab.enable = true;
  };

  defaults = {
    plugins.neotab = {
      enable = true;
      settings = {
        tabkey = "<Tab>";
        reverse_key = "<S-Tab>";
        act_as_tab = true;
        behavior = "nested";
        pairs = [
          {
            open = "(";
            close = ")";
          }
          {
            open = "[";
            close = "]";
          }
          {
            open = "{";
            close = "}";
          }
          {
            open = "<";
            close = ">";
          }
          {
            open = "'";
            close = "'";
          }
          {
            open = "\"";
            close = "\"";
          }
          {
            open = "`";
            close = "`";
          }
        ];
        exclude = [ ];
        smart_punctuators = {
          enabled = false;
          semicolon = {
            enabled = false;
            ft = [
              "cs"
              "c"
              "cpp"
              "java"
            ];
          };
          escape = {
            enabled = false;
            triggers.__empty = { };
          };
        };
      };
    };
  };

  example = {
    plugins.neotab = {
      enable = true;
      settings = {
        tabkey = "";
        behavior = "closing";
        exclude = [ "markdown" ];
        smart_punctuators.escape = {
          enabled = true;
          triggers."+" = {
            pairs = [
              {
                open = "\"";
                close = "\"";
              }
            ];
            format = " %s ";
            ft = [ "java" ];
          };
        };
      };
    };
  };
}
