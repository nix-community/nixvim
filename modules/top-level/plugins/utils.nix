lib:
lib.fix (self: {
  normalizedPluginType = lib.types.submodule {
    options = {
      plugin = lib.mkOption {
        type = lib.types.package;
      };

      config = lib.mkOption {
        type = with lib.types; nullOr str;
      };

      optional = lib.mkOption {
        type = lib.types.bool;
      };
    };
  };

  # Normalize a plugin in a standard { plugin, config, optional } attrs
  normalizePlugin =
    p:
    let
      defaultPlugin = {
        plugin = null;
        config = null;
        optional = false;
      };
    in
    defaultPlugin // (if p ? plugin then p else { plugin = p; });

  # Normalize a list of plugins
  normalizePlugins = map self.normalizePlugin;

  getAndNormalizeDeps = p: self.normalizePlugins (p.plugin.dependencies or [ ]);

  # Remove dependencies from all plugins in a list
  removeDeps = map (p: p // { plugin = removeAttrs p.plugin [ "dependencies" ]; });

  # Apply a map function to each 'plugin' attr of the normalized plugin list
  mapNormalizedPlugins = f: map (p: p // { plugin = f p.plugin; });
})
