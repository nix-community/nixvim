# mkSourcePlugin, returns a module
sourceType: sourceName:
{
  config,
  pkgs,
  lib,
  helpers,
  ...
}:
let
  inherit (import ./packages.nix pkgs) packaged;
  pkg = packaged.${sourceName};

  cfg = config.plugins.none-ls;
  cfg' = config.plugins.none-ls.sources.${sourceType}.${sourceName};
in
{
  options.plugins.none-ls.sources.${sourceType}.${sourceName} =
    {
      enable = lib.mkEnableOption "the ${sourceName} ${sourceType} source for none-ls";
      withArgs = helpers.mkNullOrOption helpers.nixvimTypes.strLua ''
        Raw Lua code passed as an argument to the source's `with` method.
      '';
    }
    # Only declare a package option if a package is required
    // lib.optionalAttrs (packaged ? ${sourceName}) {
      package = lib.mkOption (
        {
          type = lib.types.nullOr lib.types.package;
          description =
            "Package to use for ${sourceName}."
            + (lib.optionalString (pkg == null) (
              "\n\n"
              + ''
                Currently not packaged in nixpkgs.
                Either set this to `null` and install ${sourceName} outside of nix,
                or set this to a custom nix package.
              ''
            ));
        }
        // lib.optionalAttrs (pkg != null) { default = pkg; }
      );
    };

  config = lib.mkIf (cfg.enable && cfg'.enable) {
    plugins.none-ls.settings.sources = lib.mkDefault [
      (
        "require('null-ls').builtins.${sourceType}.${sourceName}"
        + lib.optionalString (cfg'.withArgs != null) ".with(${cfg'.withArgs})"
      )
    ];

    extraPackages = [ (cfg'.package or null) ];
  };
}
