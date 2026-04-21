{
  lib,
  utils,
}:
{
  name,
  maintainers,
  url ? null,
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
  # Can be a string, a list of strings, or a module option:
  # - A string will be intrpreted as `pkgs.vimPlugins.${package}`
  # - A list will be interpreted as a "pkgs path", e.g. `pkgs.${elem1}.${elem2}.${etc...}`
  # - An option will be used as-is, but should be built using `lib.mkPackageOption`
  # Defaults to `name`, i.e. `pkgs.vimPlugins.${name}`
  package ? name,
  # Which dependencies to enable by default
  dependencies ? [ ],
  settingsOptions ? { },
  settingsExample ? null,
  settingsDescription ? "Options provided to the `require('${moduleName}')${setup}` function.",
  hasSettings ? true,
  extraOptions ? { },
  # config
  moduleName ? name,
  setup ? ".setup",
  extraConfig ? cfg: { },
  extraPlugins ? [ ],
  extraPackages ? [ ],
  callSetup ? true,
}@args:
let
  validCallSetupModes = [
    true
    false
    "optional"
  ];
  optionDefaultPriority = (lib.mkOptionDefault null).priority;
  namespace = if isColorscheme then "colorschemes" else "plugins";
  loc = [
    namespace
    name
  ];

  module =
    { config, options, ... }:
    let
      cfg = lib.getAttrFromPath loc config;
      opts = lib.getAttrFromPath loc options;
      settingsWereDefined =
        hasSettings && (opts.settings.highestPrio or optionDefaultPriority) < optionDefaultPriority;
      setupCode = ''
        require('${moduleName}')${setup}(${
          lib.optionalString (cfg ? settings) (lib.nixvim.toLuaObject cfg.settings)
        })
      '';
      setupContent =
        if callSetup == true then
          setupCode
        else if callSetup == "optional" then
          lib.optionalString settingsWereDefined setupCode
        else
          "";

      luaConfigAtLocation = utils.mkConfigAt configLocation cfg.luaConfig.content;
    in
    {
      options = lib.setAttrByPath loc (
        {
          enable = lib.mkEnableOption name;
          autoLoad = lib.nixvim.mkAutoLoadOption cfg name;
          lazyLoad = lib.nixvim.mkLazyLoadOption name;
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
        // extraOptions
      );

      config =
        assert lib.assertMsg (lib.elem callSetup validCallSetupModes) ''
          Unexpected `callSetup` value for `${lib.showOption loc}`.
          Expected one of: true, false, "optional"
        '';
        assert lib.assertMsg (
          callSetup != false -> hasLuaConfig
        ) "This plugin is supposed to call the `setup()` function but has `hasLuaConfig` set to false";
        assert lib.assertMsg (
          callSetup != "optional" || hasSettings
        ) "This plugin uses `callSetup = \"optional\"` but has `hasSettings` set to false";
        lib.mkIf cfg.enable (
          lib.mkMerge (
            [
              { inherit extraPackages extraPlugins; }

              (lib.optionalAttrs (isColorscheme && colorscheme != null) {
                colorscheme = lib.mkDefault colorscheme;
              })

              # Apply any additional configuration added to `extraConfig`
              (lib.optionalAttrs (args ? extraConfig) (
                utils.applyExtraConfig {
                  inherit extraConfig cfg opts;
                }
              ))

              (lib.nixvim.plugins.utils.enableDependencies dependencies)

              # When lazy loading is enabled for this plugin, route its configuration to the enabled provider
              (lib.mkIf cfg.lazyLoad.enable {
                assertions = [
                  {
                    assertion = (isColorscheme && colorscheme != null) || cfg.lazyLoad.settings != { };
                    message = "You have enabled lazy loading for ${name} but have not provided any configuration.";
                  }
                ];

                plugins.lz-n = {
                  plugins = [
                    (
                      {
                        # The packpath name is always the derivation name
                        __unkeyed-1 = lib.getName cfg.package;
                        # Use provided after, otherwise fallback to normal function wrapped lua content
                        after =
                          let
                            after = cfg.lazyLoad.settings.after or null;
                            default = if hasLuaConfig then "function()\n " + cfg.luaConfig.content + " \nend" else null;
                          in
                          if (lib.isString after || lib.types.rawLua.check after) then after else default;
                        colorscheme = lib.mkIf isColorscheme (cfg.lazyLoad.settings.colorscheme or colorscheme);
                      }
                      // lib.removeAttrs cfg.lazyLoad.settings [
                        "after"
                        "colorscheme"
                      ]
                    )
                  ];
                };
              })
            ]
            # Lua configuration code generation
            ++ lib.optionals hasLuaConfig [

              # Add the plugin setup code `require('foo').setup(...)` to the lua configuration
              (lib.optionalAttrs (callSetup != false) (
                lib.setAttrByPath loc { luaConfig.content = setupContent; }
              ))

              # When NOT lazy loading, write `luaConfig.content` to `configLocation`
              (lib.mkIf (!cfg.lazyLoad.enable) luaConfigAtLocation)
            ]
          )
        );
    };
in
{
  imports =
    let
      settingsPath = loc ++ [ "settings" ];
    in
    imports
    ++ [
      module
      (utils.mkPluginPackageModule { inherit loc name package; })
      (utils.mkMetaModule {
        inherit
          loc
          maintainers
          description
          url
          ;
      })
    ]
    ++ lib.optional deprecateExtraOptions (
      lib.mkRenamedOptionModule (loc ++ [ "extraOptions" ]) settingsPath
    )
    ++ lib.nixvim.mkSettingsRenamedOptionModules loc settingsPath optionsRenamedToSettings;
}
