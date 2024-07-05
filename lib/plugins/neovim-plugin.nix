{
  lib,
  nixvimOptions,
  toLuaObject,
  nixvimUtils,
  mkPlugin,
}:
with lib;
{
  # TODO: DEPRECATED: use the `settings` option instead
  extraOptionsOptions = {
    extraOptions = mkOption {
      default = { };
      type = with types; attrsOf anything;
      description = ''
        These attributes will be added to the table parameter for the setup function.
        Typically, it can override NixVim's default settings.
      '';
    };
  };

  mkNeovimPlugin =
    config:
    {
      name,
      defaultPackage, # make this parameter mandatory for neovim plugins
      # deprecations
      deprecateExtraOptions ? false,
      # colorscheme
      isColorscheme ? false,
      # options
      settingsOptions ? { },
      settingsExample ? null,
      settingsDescription ? "Options provided to the `require('${luaName}')${setup}` function.",
      hasSettings ? true,
      extraOptions ? { },
      # config
      setup ? ".setup",
      luaName ? name,
      callSetup ? true,
      ...
    }@args:
    mkPlugin config (
      (removeAttrs args [
        "callSetup"
        "deprecateExtraOptions"
        "extraConfig"
        "extraOptions"
        "hasSettings"
        "imports"
        "luaName"
        "settingsExample"
        "settingsOptions"
      ])
      // {
        imports =
          let
            basePluginPath = [
              (if isColorscheme then "colorschemes" else "plugins")
              name
            ];
            settingsPath = basePluginPath ++ [ "settings" ];
          in
          (args.imports or [ ])
          ++ (optional deprecateExtraOptions (
            mkRenamedOptionModule (basePluginPath ++ [ "extraOptions" ]) settingsPath
          ));

        extraOptions =
          (optionalAttrs hasSettings {
            settings = nixvimOptions.mkSettingsOption {
              description = settingsDescription;
              options = settingsOptions;
              example = settingsExample;
            };
          })
          // extraOptions;

        extraConfig =
          let
            extraConfigNamespace = if isColorscheme then "extraConfigLuaPre" else "extraConfigLua";
          in
          cfg:
          mkMerge (
            [
              {
                ${extraConfigNamespace} = optionalString callSetup ''
                  require('${luaName}')${setup}(${optionalString (cfg ? settings) (toLuaObject cfg.settings)})
                '';
              }
            ]
            ++ (optional (args ? extraConfig) (args.extraConfig cfg))
          );
      }
    );
}
