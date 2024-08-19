{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts toLuaObject;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "ayu";
  isColorscheme = true;
  originalName = "neovim-ayu";
  package = "neovim-ayu";
  # The colorscheme option is set by the `setup` function.
  colorscheme = null;
  callSetup = false;

  maintainers = [ lib.maintainers.GaetanLepage ];

  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "mirage"
    "overrides"
  ];

  settingsOptions = {
    mirage = defaultNullOpts.mkBool false ''
      Set to `true` to use `mirage` variant instead of `dark` for dark background.
    '';

    overrides = defaultNullOpts.mkStrLuaOr (with lib.types; attrsOf highlight) { } ''
      A dictionary of group names, each associated with a dictionary of parameters
      (`bg`, `fg`, `sp` and `style`) and colors in hex.

      Alternatively, `overrides` can be a function that returns a dictionary of the same
      format.
      You can use the function to override based on a dynamic condition, such as the value of
      `background`.
    '';
  };

  extraConfig = cfg: {
    colorschemes.ayu.luaConfig.content = ''
      local ayu = require("ayu")
      ayu.setup(${toLuaObject cfg.settings})
      ayu.colorscheme()
    '';
  };
}
