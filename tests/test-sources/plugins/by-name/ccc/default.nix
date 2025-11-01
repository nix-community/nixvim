{
  empty = {
    plugins.ccc.enable = true;
  };

  defaults = {
    plugins.ccc = {
      enable = true;
      settings = {
        default_color = "#000000";
        inputs = [
          "ccc.input.rgb"
          "ccc.input.hsl"
          "ccc.input.cmyk"
        ];
        outputs = [
          "ccc.output.hex"
          "ccc.output.hex_short"
          "ccc.output.css_rgb"
          "ccc.output.css_hsl"
        ];
        pickers = [
          "ccc.picker.hex"
          "ccc.picker.css_rgb"
          "ccc.picker.css_hsl"
          "ccc.picker.css_hwb"
          "ccc.picker.css_lab"
          "ccc.picker.css_lch"
          "ccc.picker.css_oklab"
          "ccc.picker.css_oklch"
        ];
        highlight_mode = "bg";
        lsp = true;
        highlighter = {
          auto_enable = false;
          filetypes.__empty = { };
          excludes.__empty = { };
          lsp = true;
          update_insert = true;
        };
        convert = [
          [
            "ccc.picker.hex"
            "ccc.output.css_rgb"
          ]
          [
            "ccc.picker.css_rgb"
            "ccc.output.css_hsl"
          ]
          [
            "ccc.picker.css_hsl"
            "ccc.output.hex"
          ]
        ];
      };
    };
  };

  example = {
    plugins.ccc = {
      enable = true;
      settings = {
        default_color = "#FFFFFF";
        inputs = [
          "ccc.input.oklab"
          "ccc.input.oklch"
        ];
        outputs = [
          "ccc.output.css_oklab"
          "ccc.output.css_oklch"
        ];
        pickers = [
          "ccc.picker.css_oklch"
          "ccc.picker.css_name"
          "ccc.picker.hex"
        ];
        highlight_mode = "fg";
        lsp = false;
        highlighter = {
          auto_enable = true;
          lsp = false;
          excludes = [ "markdown" ];
          update_insert = false;
        };
        convert = [
          [
            "ccc.picker.hex"
            "ccc.output.css_oklch"
          ]
          [
            "ccc.picker.css_oklch"
            "ccc.output.hex"
          ]
        ];
      };
    };
  };
}
