{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "plantuml-syntax";
  globalPrefix = "plantuml_";
  description = "Syntax highlighting for PlantUML files.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "setMakeprg"
    "executableScript"
  ];
  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "plantuml-syntax";
      packageName = "plantuml";
    })
  ];

  dependencies = [ "plantuml" ];

  settingsOptions = {
    set_makeprg = defaultNullOpts.mkFlagInt 1 ''
      Set the makeprg to `plantuml`.
    '';

    executable_script = defaultNullOpts.mkStr "plantuml" ''
      Set the script to be called with makeprg, default to `plantuml` in `$PATH`.
    '';
  };

  settingsExample = {
    set_makeprg = true;
    executable_script = "plantuml";
  };
}
