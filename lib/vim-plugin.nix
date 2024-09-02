{ lib, helpers }:
with lib;
{
  mkVimPlugin =
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
      originalName ? name,
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

      createSettingsOption = (isString globalPrefix) && (globalPrefix != "");

      settingsOption = optionalAttrs createSettingsOption {
        settings = helpers.mkSettingsOption {
          options = settingsOptions;
          example = settingsExample;
          description = ''
            The configuration options for **${name}** without the `${globalPrefix}` prefix.

            For example, the following settings are equivialent to these `:setglobal` commands:
            - `foo_bar = 1` -> `:setglobal ${globalPrefix}foo_bar=1`
            - `hello = "world"` -> `:setglobal ${globalPrefix}hello="world"`
            - `some_toggle = true` -> `:setglobal ${globalPrefix}some_toggle`
            - `other_toggle = false` -> `:setglobal no${globalPrefix}other_toggle`
          '';
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
          cfg = config.${namespace}.${name};
          opt = options.${namespace}.${name};
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

          options.${namespace}.${name} = {
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
          } // settingsOption // extraOptions;

          config = mkIf cfg.enable (mkMerge [
            {
              inherit extraPackages;
              globals = mapAttrs' (n: nameValuePair (globalPrefix + n)) (cfg.settings or { });
              # does this evaluate package? it would not be desired to evaluate package if we use another package.
              extraPlugins = extraPlugins ++ optional (cfg.package != null) cfg.package;
            }
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
        ++ (optional (deprecateExtraConfig && createSettingsOption) (
          mkRenamedOptionModule (basePluginPath ++ [ "extraConfig" ]) settingsPath
        ))
        ++ (nixvim.mkSettingsRenamedOptionModules basePluginPath settingsPath optionsRenamedToSettings);
    };
}
