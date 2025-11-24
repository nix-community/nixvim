{ lib }:
{
  empty = {
    plugins.blink-indent.enable = true;
  };

  defaults = {
    plugins.blink-indent = {
      enable = true;

      settings = {
        blocked = {
          buftypes.include_defaults = true;
          filetypes.include_defaults = true;
        };

        mappings = {
          border = "both";
          object_scope = "ii";
          object_scope_with_border = "ai";
          goto_top = "[i";
          goto_bottom = "]i";
        };

        static = {
          enabled = true;
          char = "▎";
          whitespace_char = lib.nixvim.mkRaw "nil";
          priority = 1;
          highlights = [ "BlinkIndent" ];
        };

        scope = {
          enabled = true;
          char = "▎";
          priority = 1000;

          highlights = [
            "BlinkIndentOrange"
            "BlinkIndentViolet"
            "BlinkIndentBlue"
          ];

          underline = {
            enabled = false;

            highlights = [
              "BlinkIndentOrangeUnderline"
              "BlinkIndentVioletUnderline"
              "BlinkIndentBlueUnderline"
            ];
          };
        };
      };
    };
  };

  example = {
    plugins.blink-indent = {
      enable = true;

      settings = {
        static.highlights = [
          "BlinkIndentRed"
          "BlinkIndentOrange"
          "BlinkIndentYellow"
          "BlinkIndentGreen"
          "BlinkIndentViolet"
          "BlinkIndentCyan"
        ];

        scope.underline.enable = true;
      };
    };
  };
}
