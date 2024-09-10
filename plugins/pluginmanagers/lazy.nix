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
      hasNonNullAttr = str: attrs: (builtins.hasAttr str attrs) && (attrs."${str}" != null);
      hasNonNullName = plugin: hasNonNullAttr "name" plugin;
      hasNonNullPkg = plugin: hasNonNullAttr "pkg" plugin;
      hasNonNullPackages = plugin: hasNonNullAttr "packages" plugin;
      hasNonNullDependencies = plugin: hasNonNullAttr "dependencies" plugin;

      mkEntryFromDrv =
        p:
        if lib.isDerivation p then
          {
            name = "${lib.getName p}";
            path = p;
          }
        else
          {
            name =
              if hasNonNullName p then
                p.name
              else if hasNonNullPkg p then
                "${lib.getName p.pkg}"
              else
                "${lib.getName p.path}";
            path = if p ? path then p.path else p.pkg;
          };
      processPackages =
        if hasNonNullPackages plugin then
          if lib.isList plugin.packages then
            builtins.concatMap processPlugin plugin.packages
          else
            builtins.concatMap processPlugin [ plugin.packages ]
        else
          [ ];
      processDependencies =
        if hasNonNullDependencies plugin then builtins.concatMap processPlugin plugin.dependencies else [ ];
    in
    [ (mkEntryFromDrv plugin) ] ++ processPackages ++ processDependencies;

  processedPlugins = builtins.concatLists (builtins.map processPlugin lazyPlugins);
  lazyPath = pkgs.linkFarm "lazy-plugins" processedPlugins;
in
{
  options = {
    plugins.lazy = {
      enable = mkEnableOption "lazy.nvim";

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

              import = helpers.mkNullOrOption (helpers.nixvimTypes.eitherRecursive str (listOf str)) "Name of additional plugin module/modules to import";

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

              packages = helpers.mkNullOrOption (helpers.nixvimTypes.eitherRecursive types.package listOfPackages) "Additional packages to be made available in the `lazy-plugins` path";

              dependencies = helpers.mkNullOrOption (helpers.nixvimTypes.eitherRecursive str listOfPlugins) "Plugin dependencies";

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
                with helpers.nixvimTypes;
                helpers.mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on event. Events can be specified as BufEnter or with a pattern like BufEnter *.lua";

              cmd =
                with helpers.nixvimTypes;
                helpers.mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on command";

              ft =
                with helpers.nixvimTypes;
                helpers.mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on filetype";

              keys =
                with helpers.nixvimTypes;
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
                with helpers.nixvimTypes;
                helpers.mkNullOrOption (maybeRaw (attrsOf anything)) ''
                  opts should be a table (will be merged with parent specs),
                  return a table (replaces parent specs) or should change a table.
                  The table will be passed to the Plugin.config() function.
                  Setting this value will imply Plugin.config()
                '';
            };
          });

          listOfPackages = types.listOf (helpers.nixvimTypes.eitherRecursive types.package types.attrs);
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
    extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];
    extraPackages = [ pkgs.git ];

    extraConfigLua =
      let
        pluginToLua =
          plugin:
          let
            keyExists = keyToCheck: attrSet: lib.elem keyToCheck (lib.attrNames attrSet);
            pluginImportToLua = pluginImport: { import = pluginImport; };
          in
          if isDerivation plugin then
            { dir = "${lazyPath}/${lib.getName plugin}"; }
          else
            [
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

                import = helpers.ifNonNull' plugin.import (if isList plugin.import then null else plugin.import);

                dependencies = helpers.ifNonNull' plugin.dependencies (
                  if isList plugin.dependencies then (pluginListToLua plugin.dependencies) else plugin.dependencies
                );

                dir =
                  if plugin ? dir && plugin.dir != null then plugin.dir else "${lazyPath}/${lib.getName plugin.pkg}";
              }
            ]
            ++ (if isList plugin.import then (map pluginImportToLua plugin.import) else [ ]);

        pluginListToLua = pluginList: flatten (map pluginToLua pluginList);

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
