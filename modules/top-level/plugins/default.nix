{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (import ./utils.nix lib)
    normalizedPluginType
    normalizePlugins
    ;
  byteCompileCfg = config.performance.byteCompileLua;
in
{
  options = {
    build.plugins = lib.mkOption {
      visible = false;
      internal = true;
      readOnly = true;
      type = lib.types.listOf normalizedPluginType;
      description = ''
        Final list of (normalized) plugins that will be passed to the wrapper.

        It notably implements:
        - byte-compilation (performance.byteCompileLua) -> ./byte-compile-plugins.nix
        - plugins combining (performance.combinePlugins) -> ./combine-plugins.nix
      '';
    };
  };

  config = {
    build.plugins =
      let
        shouldCompilePlugins = byteCompileCfg.enable && byteCompileCfg.plugins;
        byteCompilePlugins = import ./byte-compile-plugins.nix { inherit lib pkgs; };

        shouldCombinePlugins = config.performance.combinePlugins.enable;
        combinePlugins = import ./combine-plugins.nix {
          inherit lib pkgs;
          inherit (config.performance.combinePlugins)
            standalonePlugins
            pathsToLink
            ;
        };
      in

      lib.pipe config.extraPlugins (
        [ normalizePlugins ]
        ++ lib.optionals shouldCompilePlugins [ byteCompilePlugins ]
        ++ lib.optionals shouldCombinePlugins [ combinePlugins ]
      );
  };
}
