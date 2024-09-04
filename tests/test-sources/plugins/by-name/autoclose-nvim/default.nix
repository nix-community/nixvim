{
  empty = {
    plugins.autoclose.enable = true;
  };

  defaults = {
    plugins.autoclose.enable = true;
    plugins.autoclose = {
      keys = {
        "(" = {
          escape = false;
          close = true;
          pair = "()";
        };
        "[" = {
          escape = false;
          close = true;
          pair = "[]";
        };
        "{" = {
          escape = false;
          close = true;
          pair = "{}";
        };

        ">" = {
          escape = true;
          close = false;
          pair = "<>";
        };
        ")" = {
          escape = true;
          close = false;
          pair = "()";
        };
        "]" = {
          escape = true;
          close = false;
          pair = "[]";
        };
        "}" = {
          escape = true;
          close = false;
          pair = "{}";
        };
        "\"" = {
          escape = true;
          close = true;
          pair = ''""'';
        };
        "'" = {
          escape = true;
          close = true;
          pair = "''";
        };
        "`" = {
          escape = true;
          close = true;
          pair = "``";
        };
      };

      options = {
        disabledFiletypes = [ "text" ];
        disableWhenTouch = false;
        touchRegex = "[%w(%[{]";
        pairSpaces = false;
        autoIndent = true;
        disableCommandMode = false;
      };
    };
  };
}
