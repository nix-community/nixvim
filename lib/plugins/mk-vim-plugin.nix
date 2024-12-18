{ lib }:
let
  inherit (lib.nixvim.plugins.vim)
    mkSettingsOption
    ;
in
{
  name,
  url ? throw "default",
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
    settings = mkSettingsOption {
      options = settingsOptions;
      example = settingsExample;
      inherit name globalPrefix;
    };
  };

  module =
    {
      config,
      options,
      pkgs,
      ...
    }:
    let
      cfg = lib.getAttrFromPath loc config;
      opts = lib.getAttrFromPath loc options;
    in
    {
      meta = {
        inherit maintainers;
        nixvimInfo = {
          inherit description;
          url = args.url or opts.package.default.meta.homepage;
          path = loc;
        };
      };

      options = lib.setAttrByPath loc (
        {
          enable = lib.mkEnableOption packPathName;
          package =
            if lib.isOption package then
              package
            else
              lib.mkPackageOption pkgs packPathName {
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
        // settingsOption
        // extraOptions
      );

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            inherit extraPackages;
            extraPlugins = extraPlugins ++ [
              (cfg.packageDecorator cfg.package)
            ];
            globals = lib.nixvim.applyPrefixToAttrs globalPrefix (cfg.settings or { });
          }
          (lib.optionalAttrs (isColorscheme && colorscheme != null) {
            colorscheme = lib.mkDefault colorscheme;
          })
          (lib.optionalAttrs (args ? extraConfig) (
            lib.nixvim.modules.applyExtraConfig {
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
    ++ [ module ]
    ++ lib.optional (deprecateExtraConfig && createSettingsOption) (
      lib.mkRenamedOptionModule (loc ++ [ "extraConfig" ]) settingsPath
    )
    ++ lib.nixvim.mkSettingsRenamedOptionModules loc settingsPath optionsRenamedToSettings;
}
