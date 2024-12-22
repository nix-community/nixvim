{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "plantuml-syntax";
  globalPrefix = "plantuml_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "setMakeprg"
    "executableScript"
  ];

  extraOptions = {
    plantumlPackage = lib.mkPackageOption pkgs "plantuml" {
      nullable = true;
    };
  };

  extraConfig = cfg: { extraPackages = [ cfg.plantumlPackage ]; };

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
