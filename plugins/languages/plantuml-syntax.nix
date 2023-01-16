{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.plugins.plantuml-syntax = {
    enable = mkEnableOption "Enable plantuml syntax support";
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

  config = let
    cfg = config.plugins.plantuml-syntax;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [plantuml-syntax];

      globals = {
        plantuml_set_makeprg = cfg.setMakeprg;
        plantuml_executable_script = cfg.executableScript;
      };
    };
}
