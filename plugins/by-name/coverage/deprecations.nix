lib: {
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "autoReload"
    "autoReloadTimeoutMs"
    "commands"
    "highlights"
    "loadCoverageCb"
    "signs"
  ];
  imports =
    let
      basePluginsPath = [
        "plugins"
        "coverage"
      ];
      message = ''
        Use Nixvim top-level `keyamps` option to manually declare your 'nvim-coverage' keymaps.
      '';
    in
    [
      (lib.mkRemovedOptionModule (basePluginsPath ++ [ "keymaps" ]) message)
      (lib.mkRemovedOptionModule (basePluginsPath ++ [ "keymapsSilent" ]) message)
    ];
}
