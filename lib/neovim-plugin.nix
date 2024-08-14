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
    config:
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
      # lazyLoad
      allowLazyLoad ? true,
      packageName ? originalName, # Name of the package folder created in {runtimepath}/pack/start or {runtimepath}/pack/opt
      lazyLoadDefaults ? { },
    }:
    let
      namespace = if isColorscheme then "colorschemes" else "plugins";
      cfg = config.${namespace}.${name};
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
        ++ (map (
          option:
          let
            optionPath = if isString option then [ option ] else option; # option is already a path (i.e. a list)

            optionPathSnakeCase = map helpers.toSnakeCase optionPath;
          in
          mkRenamedOptionModule (basePluginPath ++ optionPath) (settingsPath ++ optionPathSnakeCase)
        ) optionsRenamedToSettings);

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
        // optionalAttrs allowLazyLoad {
          lazyLoad = helpers.mkLazyLoadOption {
            inherit originalName;
            lazyLoadDefaults =
              (optionalAttrs (isColorscheme && colorscheme != null) { inherit colorscheme; }) // lazyLoadDefaults;
          };
        }
        // extraOptions;

      config =
        let
          extraConfigNamespace = if isColorscheme then "extraConfigLuaPre" else "extraConfigLua";
          lazyLoaded = cfg.lazyLoad.enable or false;

          # lz-n lazyLoad backend
          # Transform plugin into attrset and set optional to true
          # See `tests/test-sources/plugins/pluginmanagers/lz-n.nix`
          optionalPlugin =
            x:
            if isColorscheme then x else ((if x ? plugin then x else { plugin = x; }) // { optional = true; });
          mkFn = str: if str != "" then "function()\n" + str + "end" else null;
        in
        mkIf cfg.enable (mkMerge [
          # Always set
          (optionalAttrs (isColorscheme && (colorscheme != null)) { colorscheme = mkDefault colorscheme; })

          # Normal loading
          (mkIf (!lazyLoaded) (mkMerge [
            (extraConfig cfg)
            {
              extraPlugins = (optional installPackage cfg.package) ++ extraPlugins;
              inherit extraPackages;
            }
            (optionalAttrs callSetup {
              ${extraConfigNamespace} = ''
                require('${luaName}')${setup}(${optionalString (cfg ? settings) (helpers.toLuaObject cfg.settings)})
              '';
            })
          ]))

          # Lazy loading with lz-n
          (mkIf (lazyLoaded && config.plugins.lz-n.enable) (mkMerge [
            (lib.removeAttrs (extraConfig cfg) [
              "extraConfigLua"
              "extraConfigLuaPre"
            ])
            {
              extraPlugins = (optional installPackage (optionalPlugin cfg.package)) ++ extraPlugins;
              inherit extraPackages;
            }
            {
              plugins.lz-n.plugins = [
                {
                  __unkeyed-1 = packageName;
                  after =
                    if cfg.lazyLoad.after == null then
                      mkFn (
                        (extraConfig cfg).extraConfigLuaPre or ""
                        + optionalString callSetup ''require('${luaName}')${setup}(${
                          optionalString (cfg ? settings) (helpers.toLuaObject cfg.settings)
                        }) ''
                        + (extraConfig cfg).extraConfigLua or ""
                      )
                    else
                      cfg.lazyLoad.after;
                  inherit (cfg.lazyLoad)
                    enabled
                    priority
                    before
                    beforeAll
                    # after defined above
                    event
                    cmd
                    ft
                    keys
                    colorscheme
                    extraSettings
                    ;
                }
              ];
            }
          ]))

          # Lazy loading with lazy.nvim
        ]);
    };
}
