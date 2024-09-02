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
      url ? throw "default",
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
      # Can be a string, a list of strings, or a module option:
      # - A string will be intrpreted as `pkgs.vimPlugins.${package}`
      # - A list will be interpreted as a "pkgs path", e.g. `pkgs.${elem1}.${elem2}.${etc...}`
      # - An option will be used as-is, but should be built using `lib.mkPackageOption`
      # Defaults to `name`, i.e. `pkgs.vimPlugins.${name}`
      package ? name,
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
    }@args:
    let
      namespace = if isColorscheme then "colorschemes" else "plugins";

      module =
        {
          config,
          options,
          pkgs,
          ...
        }:
        let
          cfg = config.${namespace}.${name};
          opt = options.${namespace}.${name};
          extraConfigNamespace = if isColorscheme then "extraConfigLuaPre" else "extraConfigLua";
        in
        {
          meta = {
            inherit maintainers;
            nixvimInfo = {
              inherit description;
              url = args.url or opt.package.default.meta.homepage;
              path = [
                namespace
                name
              ];
            };
          };

          options.${namespace}.${name} =
            {
              enable = mkEnableOption originalName;
              package =
                if lib.isOption package then
                  package
                else
                  lib.mkPackageOption pkgs originalName {
                    default =
                      if builtins.isList package then
                        package
                      else
                        [
                          "vimPlugins"
                          package
                        ];
                  };
            }
            // optionalAttrs hasSettings {
              settings = helpers.mkSettingsOption {
                description = settingsDescription;
                options = settingsOptions;
                example = settingsExample;
              };
            }
            // extraOptions;

          config = mkIf cfg.enable (mkMerge [
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
        };
    in
    {
      imports =
        let
          basePluginPath = [
            namespace
            name
          ];
          settingsPath = basePluginPath ++ [ "settings" ];
        in
        imports
        ++ [ module ]
        ++ (optional deprecateExtraOptions (
          mkRenamedOptionModule (basePluginPath ++ [ "extraOptions" ]) settingsPath
        ))
        ++ (nixvim.mkSettingsRenamedOptionModules basePluginPath settingsPath optionsRenamedToSettings);
    };
}
