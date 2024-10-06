{
  lib,
  helpers,
  config,
  ...
}:
let
  inherit (lib) mkRenamedOptionModule types;
  cfg = config.plugins.cmp-tabby;
in
{
  meta.maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: introduced 24-06-18, remove after 24.11
  imports =
    let
      basePluginPath = [
        "plugins"
        "cmp-tabby"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    [
      (mkRenamedOptionModule (basePluginPath ++ [ "extraOptions" ]) settingsPath)
      (mkRenamedOptionModule (basePluginPath ++ [ "host" ]) (settingsPath ++ [ "host" ]))
      (mkRenamedOptionModule (basePluginPath ++ [ "maxLines" ]) (settingsPath ++ [ "max_lines" ]))
      (mkRenamedOptionModule (basePluginPath ++ [ "runOnEveryKeyStroke" ]) (
        settingsPath ++ [ "run_on_every_keystroke" ]
      ))
      (mkRenamedOptionModule (basePluginPath ++ [ "stop" ]) (settingsPath ++ [ "stop" ]))
    ];

  options.plugins.cmp-tabby = {
    settings = helpers.mkSettingsOption {
      description = "Options provided to the `require('cmp_ai.config'):setup` function.";

      options = {
        host = helpers.defaultNullOpts.mkStr "http://localhost:5000" ''
          The address of the tabby host server.
        '';

        max_lines = helpers.defaultNullOpts.mkUnsignedInt 100 ''
          The max number of lines to complete.
        '';

        run_on_every_keystroke = helpers.defaultNullOpts.mkBool true ''
          Whether to run the completion on every keystroke.
        '';

        stop = helpers.defaultNullOpts.mkListOf types.str [ "\n" ] ''
          Stop character.
        '';
      };

      example = {
        host = "http://localhost:5000";
        max_lines = 100;
        run_on_every_keystroke = true;
        stop = [ "\n" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    extraConfigLua = ''
      require('cmp_tabby.config'):setup(${helpers.toLuaObject cfg.settings})
    '';
  };
}
