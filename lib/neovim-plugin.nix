{ lib }:
{
  # TODO: DEPRECATED: use the `settings` option instead
  extraOptionsOptions = {
    extraOptions = lib.mkOption {
      default = { };
      type = with lib.types; attrsOf anything;
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
      # luaConfig
      configLocation ? if isColorscheme then "extraConfigLuaPre" else "extraConfigLua",
      # Some plugin are not supposed to generate lua configuration code.
      # For example, they might just be configured through some other mean, like global variables
      hasLuaConfig ? true,
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
          opts = options.${namespace}.${name};

          setupCode = ''
            require('${luaName}')${setup}(${
              lib.optionalString (cfg ? settings) (lib.nixvim.toLuaObject cfg.settings)
            })
          '';

          setLuaConfig = lib.setAttrByPath (lib.toList configLocation);
        in
        {
          meta = {
            inherit maintainers;
            nixvimInfo = {
              inherit description;
              url = args.url or opts.package.default.meta.homepage;
              path = [
                namespace
                name
              ];
            };
          };

          options.${namespace}.${name} =
            {
              enable = lib.mkEnableOption originalName;
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
              packageDecorator = lib.mkOption {
                type = lib.types.functionTo lib.types.package;
                default = lib.id;
                defaultText = lib.literalExpression "x: x";
                description = ''
                  Additional transformations to apply to the final installed package.
                  The result of these transformations is **not** visible in the `package` option's value.
                '';
                internal = true;
              };

              lazyLoad = lib.mkOption {
                default = {
                  enable = false;
                };
                description = ''
                  Lazy load configuration settings.
                '';
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      default = false;
                      type = lib.types.bool;
                      description = ''
                        Whether to lazy load the plugin.

                        If you enable this, the plugin's lua configuration will need to be manually loaded by other means.

                        A usage would be passing the plugin's luaConfig to the `plugins.lz-n.plugins` configuration.
                      '';
                    };
                  };
                };
              };
            }
            // lib.optionalAttrs hasSettings {
              settings = lib.nixvim.mkSettingsOption {
                description = settingsDescription;
                options = settingsOptions;
                example = settingsExample;
              };
            }
            // lib.optionalAttrs hasLuaConfig {
              luaConfig = lib.mkOption {
                type = lib.types.pluginLuaConfig;
                default = { };
                description = "The plugin's lua configuration";
              };
            }
            // extraOptions;

          config =
            assert lib.assertMsg (
              callSetup -> hasLuaConfig
            ) "This plugin is supposed to call the `setup()` function but has `hasLuaConfig` set to false";
            lib.mkIf cfg.enable (
              lib.mkMerge (
                [
                  {
                    inherit extraPackages;
                    extraPlugins = extraPlugins ++ [
                      (cfg.packageDecorator cfg.package)
                    ];
                  }

                  (lib.optionalAttrs (isColorscheme && (colorscheme != null)) {
                    colorscheme = lib.mkDefault colorscheme;
                  })

                  # Apply any additional configuration added to `extraConfig`
                  (lib.optionalAttrs (args ? extraConfig) (
                    lib.nixvim.modules.applyExtraConfig {
                      inherit extraConfig cfg opts;
                    }
                  ))
                ]
                # Lua configuration code generation
                ++ (lib.optionals hasLuaConfig [

                  # Add the plugin setup code `require('foo').setup(...)` to the lua configuration
                  (lib.optionalAttrs callSetup { ${namespace}.${name}.luaConfig.content = setupCode; })

                  # Write the lua configuration `luaConfig.content` to the config file
                  (lib.mkIf (!cfg.lazyLoad.enable) (setLuaConfig cfg.luaConfig.content))
                ])
              )
            );
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
        ++ (lib.optional deprecateExtraOptions (
          lib.mkRenamedOptionModule (basePluginPath ++ [ "extraOptions" ]) settingsPath
        ))
        ++ (lib.nixvim.mkSettingsRenamedOptionModules basePluginPath settingsPath optionsRenamedToSettings);
    };
}
