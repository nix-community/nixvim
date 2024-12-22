{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts applyPrefixToAttrs;
  inherit (lib.nixvim.plugins.vim) mkSettingsOptionDescription;

  name = "openscad";
  globalPrefix = "openscad_";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;
  packPathName = "openscad.nvim";
  package = "openscad-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: Added 2024-12-17; remove after 25.05
  optionsRenamedToSettings = import ./renamed-options.nix;

  settingsOptions = {
    fuzzy_finder = defaultNullOpts.mkStr "skim" ''
      Fuzzy finder to find documentation.

      If you set this option explicitly, Nixvim will install the relevant finder plugin.
    '';

    cheatsheet_window_blend = defaultNullOpts.mkNullable (types.ints.between 0 100) 15 ''
      Transparency level of the cheatsheet window (in %).
    '';

    load_snippets = defaultNullOpts.mkBool false ''
      Whether to load predefined snippets for OpenSCAD.
    '';

    auto_open = defaultNullOpts.mkBool false ''
      Whether the openscad project automatically be opened on startup.
    '';

    default_mappings = defaultNullOpts.mkBool true ''
      Whether to enable the default mappings.
    '';

    cheatsheet_toggle_key = defaultNullOpts.mkStr "<Enter>" ''
      Keyboard shortcut for toggling the cheatsheet.
    '';

    help_trig_key = defaultNullOpts.mkStr "<A-h>" ''
      Keyboard shortcut for triggering the fuzzy-find help resource.
    '';

    help_manual_trig_key = defaultNullOpts.mkStr "<A-m>" ''
      Keyboard shortcut for manually triggering the offline OpenSCAD manual.
    '';

    exec_openscad_trig_key = defaultNullOpts.mkStr "<A-o>" ''
      Keyboard shortcut for opening the current file in OpenSCAD.
    '';

    top_toggle = defaultNullOpts.mkStr "<A-c>" ''
      Keyboard shortcut for toggling `htop` filtered for OpenSCAD processes.
    '';
  };

  settingsExample = {
    load_snippets = true;
    fuzzy_finder = "fzf";
    cheatsheet_window_blend = 15;
    auto_open = true;
  };

  settingsDescription = mkSettingsOptionDescription { inherit name globalPrefix; };

  callSetup = false;

  extraOptions = {
    fuzzyFinderPlugin = import ./fuzzy-finder-plugin-option.nix { inherit lib config pkgs; };
  };

  extraConfig = cfg: {
    plugins.openscad.luaConfig.content = ''
      require('openscad')
    '';

    globals = applyPrefixToAttrs globalPrefix cfg.settings;

    extraPlugins = [ cfg.fuzzyFinderPlugin ];
  };
}
