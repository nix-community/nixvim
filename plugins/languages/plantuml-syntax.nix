{ pkgs
, lib
, config
, ...
}:
with lib; {
  options.plugins.plantuml-syntax = {
    enable = mkEnableOption "plantuml syntax support";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.plantuml-syntax;
      description = "Plugin to use for plantuml-syntax";
    };

    setMakeprg = mkOption {
      type = types.bool;
      default = true;
      description = "Set the makeprg to 'plantuml'";
    };
    executableScript = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Set the script to be called with makeprg, default to 'plantuml' in PATH";
    };
  };

  config =
    let
      cfg = config.plugins.plantuml-syntax;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      globals = {
        plantuml_set_makeprg = cfg.setMakeprg;
        plantuml_executable_script = cfg.executableScript;
      };
    };
}
