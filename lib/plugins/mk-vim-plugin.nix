{
  lib,
  self,
}:
{
  name,
  url ? null,
  maintainers,
  imports ? [ ],
  description ? null,
  # deprecations
  deprecateExtraConfig ? false,
  optionsRenamedToSettings ? [ ],
  # colorscheme
  isColorscheme ? false,
  colorscheme ? name,
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
  globalPrefix ? "",
  extraOptions ? { },
  # config
  extraConfig ? cfg: { },
  extraPlugins ? [ ],
  extraPackages ? [ ],
}@args:
let
  namespace = if isColorscheme then "colorschemes" else "plugins";
  loc = [
    namespace
    name
  ];

  createSettingsOption = lib.isString globalPrefix && globalPrefix != "";

  settingsOption = lib.optionalAttrs createSettingsOption {
    settings = self.vim.mkSettingsOption {
      options = settingsOptions;
      example = settingsExample;
      inherit name globalPrefix;
    };
  };

  module =
    { config, options, ... }:
    let
      cfg = lib.getAttrFromPath loc config;
      opts = lib.getAttrFromPath loc options;
    in
    {
      options = lib.setAttrByPath loc (
        {
          enable = lib.mkEnableOption name;
          lazyLoad = lib.nixvim.mkLazyLoadOption name;
          autoLoad = lib.nixvim.mkAutoLoadOption cfg name;
        }
        // settingsOption
        // extraOptions
      );

      config = lib.mkIf cfg.enable (
        let
          globalsConfig = lib.nixvim.applyPrefixToAttrs globalPrefix (cfg.settings or { });
        in
        lib.mkMerge [
          { inherit extraPackages extraPlugins; }

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
                    # Use provided before, otherwise fallback to normal function wrapped globals config
                    before =
                      let
                        luaGlobals = lib.nixvim.toLuaObject globalsConfig;
                        before = cfg.lazyLoad.settings.before or null;
                        default = lib.mkIf (luaGlobals != "{ }") ''
                          function()
                            local globals = ${luaGlobals}

                            for k,v in pairs(globals) do
                              vim.g[k] = v
                            end
                          end
                        '';
                      in
                      if (lib.isString before || lib.types.rawLua.check before) then before else default;
                    colorscheme = lib.mkIf isColorscheme (cfg.lazyLoad.settings.colorscheme or colorscheme);
                  }
                  // lib.removeAttrs cfg.lazyLoad.settings [
                    "before"
                    "colorscheme"
                  ]
                )
              ];
            };
          })

          (lib.mkIf (!cfg.lazyLoad.enable) {
            globals = globalsConfig;
          })

          (lib.optionalAttrs (isColorscheme && colorscheme != null) {
            colorscheme = lib.mkDefault colorscheme;
          })

          (lib.optionalAttrs (args ? extraConfig) (
            lib.nixvim.plugins.utils.applyExtraConfig {
              inherit extraConfig cfg opts;
            }
          ))

          (lib.nixvim.plugins.utils.enableDependencies dependencies)
        ]
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
      (lib.nixvim.plugins.utils.mkPluginPackageModule { inherit loc name package; })
      (lib.nixvim.plugins.utils.mkMetaModule {
        inherit
          loc
          maintainers
          description
          url
          ;
      })
    ]
    ++ lib.optional (deprecateExtraConfig && createSettingsOption) (
      lib.mkRenamedOptionModule (loc ++ [ "extraConfig" ]) settingsPath
    )
    ++ lib.nixvim.mkSettingsRenamedOptionModules loc settingsPath optionsRenamedToSettings;
}
