{
  empty =
    { pkgs, ... }:
    {
      plugins.perfanno.enable = !pkgs.stdenv.isDarwin;
    };

  example =
    { pkgs, ... }:
    {
      plugins.perfanno = {
        enable = !pkgs.stdenv.isDarwin;

        settings = {
          line_highlights.__raw = ''require("perfanno.util").make_bg_highlights(nil, "#CC3300", 10)'';
          vt_highlight.__raw = ''require("perfanno.util").make_fg_highlight("#CC3300")'';
          formats = [
            {
              percent = true;
              format = "%.2f%%";
              minimum = 0.5;
            }
            {
              percent = false;
              format = "%d";
              minimum = 1;
            }
          ];

          annotate_after_load = true;
          annotate_on_open = true;
          telescope = {
            enabled.__raw = ''pcall(require, "telescope")'';
            annotate = true;
          };

          ts_function_patterns = {
            default = [
              "function"
              "method"
            ];
            weirdlang = [
              "weirdfunc"
            ];
          };
        };
      };
    };
}
