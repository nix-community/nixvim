{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lazy;
  lazyPlugins = cfg.plugins;

  processPlugin =
    plugin:
    let
      mkEntryFromDrv =
        p:
        if lib.isDerivation p then
          {
            name = "${lib.getName p}";
            path = p;
          }
        else
          {
            name = "${lib.getName p.pkg}";
            path = p.pkg;
          };
      processDependencies =
        if plugin ? dependencies && plugin.dependencies != null then
          builtins.concatMap processPlugin plugin.dependencies
        else
          [ ];
    in
    [ (mkEntryFromDrv plugin) ] ++ processDependencies;

  processedPlugins = builtins.concatLists (builtins.map processPlugin lazyPlugins);
  lazyPath = pkgs.linkFarm "lazy-plugins" processedPlugins;
in
{
  options = {
    plugins.lazy = {
      enable = mkEnableOption "lazy.nvim";

      package = lib.mkPackageOption pkgs [
        "vimPlugins"
        "lazy-nvim"
      ] { };

      gitPackage = lib.mkPackageOption pkgs "git" {
        nullable = true;
      };

      plugins =
        with types;
        let
          pluginType = either package (submodule {
            options = {
              dir = helpers.mkNullOrOption str "A directory pointing to a local plugin";

              pkg = mkOption {
                type = package;
                description = "Vim plugin to install";
              };

              name = helpers.mkNullOrOption str "Name of the plugin to install";

              dev = helpers.defaultNullOpts.mkBool false ''
                When true, a local plugin directory will be used instead.
                See config.dev
              '';

              lazy = helpers.defaultNullOpts.mkBool true ''
                When true, the plugin will only be loaded when needed.
                Lazy-loaded plugins are automatically loaded when their Lua modules are required,
                or when one of the lazy-loading handlers triggers
              '';

              enabled = helpers.defaultNullOpts.mkStrLuaFnOr types.bool "`true`" ''
                When false then this plugin will not be included in the spec. (accepts fun():boolean)
              '';

              cond = helpers.defaultNullOpts.mkStrLuaFnOr types.bool "`true`" ''
                When false, or if the function returns false,
                then this plugin will not be loaded. Useful to disable some plugins in vscode,
                or firenvim for example. (accepts fun(LazyPlugin):boolean)
              '';

              dependencies = helpers.mkNullOrOption (eitherRecursive str listOfPlugins) "Plugin dependencies";

              init = helpers.mkNullOrLuaFn "init functions are always executed during startup";

              config = helpers.mkNullOrStrLuaFnOr (types.enum [ true ]) ''
                config is executed when the plugin loads.
                The default implementation will automatically run require(MAIN).setup(opts).
                Lazy uses several heuristics to determine the plugin's MAIN module automatically based on the plugin's name.
                See also opts. To use the default implementation without opts set config to true.
              '';

              main = helpers.mkNullOrOption str ''
                You can specify the main module to use for config() and opts(),
                in case it can not be determined automatically. See config()
              '';

              submodules = helpers.defaultNullOpts.mkBool true ''
                When false, git submodules will not be fetched.
                Defaults to true
              '';

              event =
                with lib.types;
                helpers.mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on event. Events can be specified as BufEnter or with a pattern like BufEnter *.lua";

              cmd =
                with lib.types;
                helpers.mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on command";

              ft =
                with lib.types;
                helpers.mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on filetype";

              keys =
                with lib.types;
                helpers.mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on key mapping";

              module = helpers.mkNullOrOption (enum [ false ]) ''
                Do not automatically load this Lua module when it's required somewhere
              '';

              priority = helpers.mkNullOrOption number ''
                Only useful for start plugins (lazy=false) to force loading certain plugins first.
                Default priority is 50. It's recommended to set this to a high number for colorschemes.
              '';

              optional = helpers.defaultNullOpts.mkBool false ''
                When a spec is tagged optional, it will only be included in the final spec,
                when the same plugin has been specified at least once somewhere else without optional.
                This is mainly useful for Neovim distros, to allow setting options on plugins that may/may not be part
                of the user's plugins
              '';

              opts =
                with lib.types;
                helpers.mkNullOrOption (maybeRaw (attrsOf anything)) ''
                  opts should be a table (will be merged with parent specs),
                  return a table (replaces parent specs) or should change a table.
                  The table will be passed to the Plugin.config() function.
                  Setting this value will imply Plugin.config()
                '';
            };
          });

          listOfPlugins = types.listOf pluginType;
        in
        mkOption {
          type = listOfPlugins;
          default = [ ];
          description = "List of plugins";
        };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraPackages = [ cfg.gitPackage ];

    extraConfigLua =
      let
        pluginToLua =
          plugin:
          let
            keyExists = keyToCheck: attrSet: lib.elem keyToCheck (lib.attrNames attrSet);
          in
          if isDerivation plugin then
            { dir = "${lazyPath}/${lib.getName plugin}"; }
          else
            {
              "__unkeyed" = plugin.name;

              inherit (plugin)
                cmd
                cond
                config
                dev
                enabled
                event
                ft
                init
                keys
                lazy
                main
                module
                name
                optional
                opts
                priority
                submodules
                ;

              dependencies = helpers.ifNonNull' plugin.dependencies (
                if isList plugin.dependencies then (pluginListToLua plugin.dependencies) else plugin.dependencies
              );

              dir =
                if plugin ? dir && plugin.dir != null then plugin.dir else "${lazyPath}/${lib.getName plugin.pkg}";
            };

        pluginListToLua = map pluginToLua;

        plugins = pluginListToLua cfg.plugins;

        packedPlugins = if length plugins == 1 then head plugins else plugins;
      in
      mkIf (cfg.plugins != [ ]) ''
        require('lazy').setup(
          {
            dev = {
              path = "${lazyPath}",
              patterns = {"."},
              fallback = false
            },
            spec = ${helpers.toLuaObject packedPlugins}
          }
        )
      '';
  };
}
