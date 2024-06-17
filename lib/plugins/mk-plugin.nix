{
  lib,
  nixvimOptions,
  nixvimUtils,
}:
with lib;
config:
{
  name,
  maintainers,
  url ? defaultPackage.meta.homepage,
  imports ? [ ],
  description ? null,
  # deprecations
  optionsRenamedToSettings ? [ ],
  # colorscheme
  isColorscheme ? false,
  colorscheme ? name,
  # options
  originalName ? name,
  defaultPackage ? null,
  extraOptions ? { },
  # config
  extraConfig ? cfg: { },
  extraPlugins ? [ ],
  extraPackages ? [ ],
}:
let
  namespace = if isColorscheme then "colorschemes" else "plugins";

  optionsRenamedToSettingsWarnings =
    let
      basePluginPath = [
        namespace
        name
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    map (
      option:
      let
        optionPath = if isString option then [ option ] else option; # option is already a path (i.e. a list)

        optionPathSnakeCase = map nixvimUtils.toSnakeCase optionPath;
      in
      mkRenamedOptionModule (
        [
          namespace
          name
        ]
        ++ optionPath
      ) (settingsPath ++ optionPathSnakeCase)
    ) optionsRenamedToSettings;
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

  imports = optionsRenamedToSettingsWarnings ++ imports;

  options.${namespace}.${name} =
    {
      enable = mkEnableOption originalName;
    }
    // (optionalAttrs (defaultPackage != null) {
      package = nixvimOptions.mkPluginPackageOption originalName defaultPackage;
    })
    // extraOptions;

  config =
    let
      cfg = config.${namespace}.${name};
    in
    mkIf cfg.enable (mkMerge [
      {
        extraPlugins = extraPlugins ++ optional (defaultPackage != null) cfg.package;
        inherit extraPackages;
      }
      (extraConfig cfg)
      (optionalAttrs (isColorscheme && (colorscheme != null)) { colorscheme = mkDefault colorscheme; })
    ]);
}
