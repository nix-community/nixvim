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
      # For some plugins it may not make sense to have a configuration attribute, as they are
      # configured through some other mean, like global variables
      hasConfigAttrs ? true,
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
              lazyLoad = lib.nixvim.mkLazyLoadOption originalName;
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
            }
            // lib.optionalAttrs hasSettings {
              settings = lib.nixvim.mkSettingsOption {
                description = settingsDescription;
                options = settingsOptions;
                example = settingsExample;
              };
            }
            // lib.optionalAttrs hasConfigAttrs {
              luaConfig = lib.mkOption {
                type = lib.types.pluginLuaConfig;
                default = { };
                description = "The plugin's lua configuration";
              };
            }
            // extraOptions;

          config =
            assert lib.assertMsg (
              callSetup -> configLocation != null
            ) "When a plugin has no config attrs and has a setup function it must have a config location";
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
                  (lib.optionalAttrs (args ? extraConfig) (
                    lib.nixvim.modules.applyExtraConfig {
                      inherit extraConfig cfg opts;
                    }
                  ))
                ]
                ++ lib.optionals (!hasConfigAttrs) [
                  (lib.optionalAttrs callSetup (setLuaConfig setupCode))
                ]
                ++ lib.optionals hasConfigAttrs [
                  (lib.optionalAttrs callSetup { ${namespace}.${name}.luaConfig.content = setupCode; })
                  (lib.mkIf (!cfg.lazyLoad.enable) (
                    lib.optionalAttrs (configLocation != null) (setLuaConfig cfg.luaConfig.content)
                  ))
                  (lib.mkIf cfg.lazyLoad.enable {
                    assertions = [
                      {
                        assertion = (isColorscheme && colorscheme != null) || cfg.lazyLoad.settings != { };
                        message = "You have enabled lazy loading for ${originalName} but have not provided any configuration.";
                      }
                      {
                        assertion = cfg.lazyLoad.enable && (config.plugins.lz-n.enable || config.plugins.lazy.enable);
                        message = "You have enabled lazy loading for ${originalName} but have not enabled any lazy loading plugins.";
                      }
                    ];
                    plugins.lz-n = lib.mkIf config.plugins.lz-n.enable {
                      plugins = [
                        (
                          {
                            __unkeyed-1 = originalName;
                            # Use provided after, otherwise fallback to normal lua content
                            after =
                              cfg.lazyLoad.settings.after or
                              # We need to wrap it in a function so it doesn't execute immediately
                              ("function()\n " + cfg.luaConfig.content + " \nend");
                            colorscheme = lib.mkIf isColorscheme (cfg.lazyLoad.settings.colorscheme or colorscheme);
                          }
                          // (lib.removeAttrs cfg.lazyLoad.settings [
                            "after"
                            "colorscheme"
                          ])
                        )
                      ];
                    };
                  })
                ]
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
