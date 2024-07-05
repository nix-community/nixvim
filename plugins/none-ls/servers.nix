{
  pkgs,
  config,
  lib,
  helpers,
  ...
}:
let
  noneLsBuiltins = import ../../generated/none-ls.nix;

  inherit (import ./packages.nix pkgs) packaged unpackaged;

  # Does this builitin require a package ?
  builitinNeedsPackage = source: lib.hasAttr source packaged || lib.elem source unpackaged;
in
{
  imports = [ ./prettier.nix ];

  options.plugins.none-ls.sources = lib.mapAttrs (
    sourceType: sources:
    lib.listToAttrs (
      lib.map (source: {
        name = source;
        value =
          {
            enable = lib.mkEnableOption "the ${source} ${sourceType} source for none-ls";
            withArgs = helpers.mkNullOrOption helpers.nixvimTypes.strLua ''
              Raw Lua code passed as an argument to the source's `with` method.
            '';
          }
          // lib.optionalAttrs (builitinNeedsPackage source) {
            package =
              let
                pkg = packaged.${source} or null;
              in
              lib.mkOption (
                {
                  type = lib.types.nullOr lib.types.package;
                  description =
                    "Package to use for ${source} by none-ls. "
                    + (lib.optionalString (pkg == null) ''
                      Not handled in nixvim, either install externally and set to null or set the option with a derivation.
                    '');
                }
                // lib.optionalAttrs (pkg != null) { default = pkg; }
              );
          };
      }) sources
    )
  ) noneLsBuiltins;

  config =
    let
      cfg = config.plugins.none-ls;
      gitsignsEnabled = cfg.sources.code_actions.gitsigns.enable;

      flattenedSources = lib.flatten (
        lib.mapAttrsToList (
          sourceType: sources:
          (lib.mapAttrsToList (sourceName: source: source // { inherit sourceType sourceName; }) sources)
        ) cfg.sources
      );

      enabledSources = builtins.filter (source: source.enable) flattenedSources;
    in
    lib.mkIf cfg.enable {
      plugins.none-ls.settings.sources = lib.mkIf (enabledSources != [ ]) (
        map (
          {
            sourceType,
            sourceName,
            withArgs,
            ...
          }:
          "require('null-ls').builtins.${sourceType}.${sourceName}"
          + lib.optionalString (withArgs != null) ".with(${withArgs})"
        ) enabledSources
      );
      plugins.gitsigns.enable = lib.mkIf gitsignsEnabled true;
      extraPackages = map (source: source.package or null) enabledSources;
    };
}
