{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.colorschemes.ayu;
in {
  options = {
    colorschemes.ayu =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "ayu";

        package = helpers.mkPackageOption "ayu" pkgs.vimPlugins.neovim-ayu;

        mirage = helpers.defaultNullOpts.mkBool false ''
          Set to `true` to use `mirage` variant instead of `dark` for dark background.
        '';

        overrides =
          helpers.defaultNullOpts.mkNullable
          (
            with types;
              either
              (attrsOf helpers.nixvimTypes.highlight)
              str
          )
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
  };

  config = let
    setupOptions = with cfg;
      {
        overrides =
          if isString overrides
          then helpers.mkRaw overrides
          else overrides;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLuaPre = ''
        local ayu = require("ayu")
        ayu.setup(${helpers.toLuaObject setupOptions})
        ayu.colorscheme()
      '';
    };
}
