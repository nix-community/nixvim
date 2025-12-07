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
