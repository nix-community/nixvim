{ lib, helpers }:
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
    {
      name,
      maintainers,
      url ? defaultPackage.meta.homepage,
      imports ? [ ],
      description ? null,
      # deprecations
      deprecateExtraOptions ? false,
      optionsRenamedToSettings ? [ ],
      # colorscheme
      isColorscheme ? false,
      colorscheme ? name,
      # options
      originalName ? name,
      defaultPackage,
      settingsOptions ? { },
      settingsExample ? null,
      settingsDescription ? "Options provided to the `require('${luaName}')${setup}` function.",
      hasSettings ? true,
      extraOptions ? { },
      # config
      luaName ? name,
      setup ? ".setup",
      extraConfig ? cfg: { },
      extraPlugins ? [ ],
      extraPackages ? [ ],
      callSetup ? true,
      installPackage ? true,
    }:
    let
      namespace = if isColorscheme then "colorschemes" else "plugins";
    in
    {
      meta = {
        inherit maintainers;
        nixvimInfo = {
          inherit description url;
          path = [
            namespace
            name
          ];
        };
      };

      imports =
        let
          basePluginPath = [
            namespace
            name
          ];
          settingsPath = basePluginPath ++ [ "settings" ];
        in
        imports
        ++ (optional deprecateExtraOptions (
          mkRenamedOptionModule (basePluginPath ++ [ "extraOptions" ]) settingsPath
        ))
        ++ (nixvim.mkSettingsRenamedOptionModules basePluginPath settingsPath optionsRenamedToSettings)
        ++ [
          (
            { config, ... }:
            {
              config =
                let
                  cfg = config.${namespace}.${name};
                  extraConfigNamespace = if isColorscheme then "extraConfigLuaPre" else "extraConfigLua";
                in
                mkIf cfg.enable (mkMerge [
                  {
                    extraPlugins = (optional installPackage cfg.package) ++ extraPlugins;
                    inherit extraPackages;
                  }
                  (optionalAttrs callSetup {
                    ${extraConfigNamespace} = ''
                      require('${luaName}')${setup}(${optionalString (cfg ? settings) (helpers.toLuaObject cfg.settings)})
                    '';
                  })
                  (optionalAttrs (isColorscheme && (colorscheme != null)) { colorscheme = mkDefault colorscheme; })
                  (extraConfig cfg)
                ]);
            }
          )
        ];

      options.${namespace}.${name} =
        {
          enable = mkEnableOption originalName;

          package = helpers.mkPluginPackageOption originalName defaultPackage;
        }
        // optionalAttrs hasSettings {
          settings = helpers.mkSettingsOption {
            description = settingsDescription;
            options = settingsOptions;
            example = settingsExample;
          };
        }
        // extraOptions;
    };
}
