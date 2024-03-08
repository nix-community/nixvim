{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "ayu";
    colorscheme = true;
    originalName = "neovim-ayu";
    defaultPackage = pkgs.vimPlugins.neovim-ayu;
    callSetup = false;

    maintainers = [maintainers.GaetanLepage];

    deprecateExtraOptions = true;
    optionsRenamedToSettings = [
      "mirage"
      "overrides"
    ];

    settingsOptions = {
      mirage = helpers.defaultNullOpts.mkBool false ''
        Set to `true` to use `mirage` variant instead of `dark` for dark background.
      '';

      overrides =
        helpers.defaultNullOpts.mkStrLuaOr
        (with helpers.nixvimTypes; attrsOf highlight)
        "{}"
        ''
          A dictionary of group names, each associated with a dictionary of parameters
          (`bg`, `fg`, `sp` and `style`) and colors in hex.

          Alternatively, `overrides` can be a function that returns a dictionary of the same
          format.
          You can use the function to override based on a dynamic condition, such as the value of
          `background`.
        '';
    };

    extraConfig = cfg: {
      # The colorscheme option is set by the `setup` function.
      colorscheme = null;

      extraConfigLuaPre = ''
        local ayu = require("ayu")
        ayu.setup(${helpers.toLuaObject cfg.settings})
        ayu.colorscheme()
      '';
    };
  }
