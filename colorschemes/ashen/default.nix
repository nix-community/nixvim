{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "ashen";
  isColorscheme = true;
  url = "https://codeberg.org/ficd/ashen.nvim";
  colorscheme = "ashen";

  maintainers = [ lib.maintainers.wokerNM ];



  settingsOptions = {
  style = {
    bold = defaultNullOpts.mkBool false "";
    italic = defaultNullOpts.mkBool false "";
  };

  style_presets = {
    bold_functions = defaultNullOpts.mkBool false "";
    italic_comments = defaultNullOpts.mkBool false "";
  };

  transparent = defaultNullOpts.mkBool false "";

  force_hi_clear = defaultNullOpts.mkBool false "";

  terminal = {
    enabled = defaultNullOpts.mkBool true "";
  };

  plugins = {
    autoload = defaultNullOpts.mkBool true "";
  };
};

}
