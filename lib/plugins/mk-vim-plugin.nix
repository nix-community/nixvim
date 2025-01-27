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
  packPathName ? name,
  # Can be a string, a list of strings, or a module option:
  # - A string will be intrpreted as `pkgs.vimPlugins.${package}`
  # - A list will be interpreted as a "pkgs path", e.g. `pkgs.${elem1}.${elem2}.${etc...}`
  # - An option will be used as-is, but should be built using `lib.mkPackageOption`
  # Defaults to `name`, i.e. `pkgs.vimPlugins.${name}`
  package ? name,
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
          enable = lib.mkEnableOption packPathName;
          autoLoad = lib.nixvim.mkAutoLoadOption cfg packPathName;
        }
        // settingsOption
        // extraOptions
      );

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            inherit extraPackages extraPlugins;
            globals = lib.nixvim.applyPrefixToAttrs globalPrefix (cfg.settings or { });
          }
          (lib.optionalAttrs (isColorscheme && colorscheme != null) {
            colorscheme = lib.mkDefault colorscheme;
          })
          (lib.optionalAttrs (args ? extraConfig) (
            lib.nixvim.plugins.utils.applyExtraConfig {
              inherit extraConfig cfg opts;
            }
          ))
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
      (lib.nixvim.plugins.utils.mkPluginPackageModule { inherit loc packPathName package; })
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
