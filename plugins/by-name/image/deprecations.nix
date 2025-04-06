lib: {
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "backend"
    "maxWidth"
    "maxHeight"
    "maxWidthWindowPercentage"
    "maxHeightWindowPercentage"
    "windowOverlapClearEnabled"
    "windowOverlapClearFtIgnore"
    "editorOnlyRenderWhenFocused"
    "tmuxShowOnlyInActiveWindow"
    "hijackFilePatterns"
  ];
  imports = [
    (lib.mkRemovedOptionModule [ "plugins" "image" "integrations" ] ''
      Nixvim(plugins.image): The option `integrations` has been renamed to `settings.integrations`.
      Warning: sub-options now have the same name as upstream (`clear_in_insert_mode`...).
    '')

    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "image";
      packageName = "curl";
    })
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "image";
      packageName = "ueberzug";
    })
  ];
}
