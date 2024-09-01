{ lib, pkgs, ... }:
let
  inherit (lib.nixvim)
    defaultNullOpts
    mkNullOrOption
    mkNullOrLuaFn
    mkNullOrStrLuaFnOr
    ;
  inherit (lib) types;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "lazy";
  originalName = "lazy.nvim";
  package = "lazy-nvim";

  maintainers = with lib.maintainers; [
    MattSturgeon
    my7h3le
  ];

  extraOptions =
    let
      # A plugin defined in the `nixvim.plugins.lazy.plugins` list can either
      # be of `types.package` or `types.str`. Depending on the type of the
      # given plugin this plugin will conditionally return an appropriate
      # plugin spec.
      coerceToLazyPluginSpec =
        plugin:
        if lib.isDerivation plugin then
          {
            dir = lib.mkDefault "${plugin}";
            name = lib.mkDefault "${lib.getName plugin}";
          }
        else if lib.isString plugin then
          { __unkeyed = lib.mkDefault plugin; }
        else
          plugin;

      lazyPluginCoercibleType = with types; either str package;

      lazyPluginType =
        with types;
        types.coercedTo lazyPluginCoercibleType coerceToLazyPluginSpec (
          submodule (
            { config, ... }:

            let
              cfg = config;
            in
            {
              freeformType = attrsOf anything;
              options = {
                __unkeyed = mkNullOrOption str ''
                  The "__unkeyed" attribute can either be one of:

                    - a local plugin directory path.
                    - a full plugin url.
                    - a short plugin url.
                    - a custom name for a plugin.

                  If a short plugin url is given e.g. "echasnovski/mini.ai" it
                  will be expanded using `plugins.lazy.settings.git.url_format`

                  If a custom name for a plugin is given, the plugin must be
                  defined somewhere else in the list of plugins. For example:

                  ```nix
                  plugins.lazy.plugins = with pkgs.vimPlugins; [
                    # Custom name for vim plugin
                    "oil"

                    # The plugin gets defined by using the custom name that was
                    # previously given.
                    {
                      name = "oil";
                      pkg = oil-nvim;
                    }
                  ];
                  ```
                '';

                dir = mkNullOrOption str ''
                  A directory pointing to a local plugin path e.g. "~/plugins/trouble.nvim".
                '';

                url = mkNullOrOption str "A custom git url where the plugin is hosted";

                pkg = mkNullOrOption package "Vim plugin to install";

                name = mkNullOrOption str "Name of the plugin to install";

                dev = defaultNullOpts.mkBool false ''
                  When true, `lazy.nvim` will look for this plugin in the local
                  plugin directory defined at `plugin.lazy.settings.dev.path`.
                '';

                lazy = defaultNullOpts.mkBool true ''
                  When true, the plugin will only be loaded when needed.

                  Lazy-loaded plugins are automatically loaded when their Lua
                  modules are required, or when one of the lazy-loading
                  handlers are triggered.

                  You can define which triggers load this plugin using
                  `plugins.lazy.plugins.<plugin>.[event|cmd|ft|keys]`.
                '';

                enabled = defaultNullOpts.mkStrLuaFnOr bool true ''
                  When false or if a function that returns false is defined
                  then this plugin will not be included in the final spec. The
                  plugin will also be uninstalled when true if the plugin is an
                  out of tree non nix package plugin. (accepts fun():boolean).
                '';

                cond = defaultNullOpts.mkStrLuaFnOr bool true ''
                  Behaves the same as enabled, but won't uninstall the plugin
                  when the condition is false. Useful to disable some plugins
                  in vscode, or firenvim for example. (this only affects out of
                  tree non nix package plugins as those are the only ones that
                  will be uninstalled by `lazy.nvim`).
                '';

                # WARNING: Be very careful if changing the type of
                # `dependencies`. Choosing the wrong type may cause a stack
                # overflow due to infinite recursion, and it's very possible
                # that the test cases won't catch this problem. To be safe,
                # perform thorough manual testing if you do change the type of
                # `dependencies`. Also use `types.eitherRecursive` instead of
                # `types.either` here, as using just `types.either` also leads
                # to stack overflow. 
                dependencies = mkNullOrOption (eitherRecursive lazyPluginType lazyPluginsListType) ''
                  A list of plugin names or plugin specs that should be
                  loaded when the plugin loads. Dependencies are always
                  lazy-loaded unless specified otherwise. When specifying a
                  name, make sure the plugin spec has been defined somewhere
                  else. This can also be a single string such as for a short
                    plugin url (See: https://lazy.folke.io/spec).
                '';

                init = mkNullOrLuaFn "init functions are always executed during startup";

                config = mkNullOrStrLuaFnOr (enum [ true ]) ''
                  config is executed when the plugin loads.

                  The default implementation will automatically run require(MAIN).setup(opts).
                  Lazy uses several heuristics to determine the plugin's MAIN module automatically based on the plugin's name.
                  See also opts. To use the default implementation without opts set config to true.
                '';

                main = mkNullOrOption str ''
                  You can specify the main module to use for config() and opts(),
                  in case it can not be determined automatically. See config()
                '';

                submodules = defaultNullOpts.mkBool true ''
                  When false, git submodules will not be fetched.
                  Defaults to true
                '';

                event = mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on event. Events can be specified as BufEnter or with a pattern like BufEnter *.lua";

                cmd = mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on command";

                ft = mkNullOrOption (maybeRaw (either str (listOf str))) ''
                  Lazy-load plugin on filetype e.g.:

                  ```nix
                  plugins.lazy.plugins = with pkgs.vimPlugins; [
                    {
                      pkg = neorg;
                      # Only load plugin on "norg" filetyes
                      ft = "norg";
                      opts = {
                        load."['core.defaults']" = [ ];
                      };
                    }
                  ];
                  ```
                '';

                keys = mkNullOrOption (maybeRaw (either str (listOf str))) "Lazy-load on key mapping";

                module = mkNullOrOption (enum [ false ]) ''
                  Do not automatically load this Lua module when it's required somewhere.
                '';

                priority = defaultNullOpts.mkInt 50 ''
                  Only useful for start plugins i.e.
                  `plugins.lazy.plugins.<plugin>.lazy = false` to force loading
                  certain plugins first. Default priority is 50. It's
                  recommended to set this to a high number for colorschemes.
                '';

                optional = defaultNullOpts.mkBool false ''
                  Optional specs are only included in the final configuration
                  if the corresponding plugin is also specified as a required
                  (non-optional) plugin elsewhere. This feature is
                  particularly helpful for Neovim distributions, allowing
                  them to pre-configure settings for plugins that users may
                  or may not have installed.
                '';

                opts = defaultNullOpts.mkAttrsOf anything { } ''
                  The opts value can be one of the following:

                  - A table: This table will be merged with any existing
                  configuration settings from parent specifications.
                  - A function that returns a table: The returned table will
                  completely replace any existing configuration settings from
                  parent specifications.
                  - A function that modifies a table: This function will
                  receive the existing configuration table as an argument and
                  can modify it directly.

                  In all cases, the resulting configuration table will be
                  passed to the Plugin.config() function. Setting the opts
                  value automatically implies that Plugin.config() will be
                  called. (See: https://lazy.folke.io/spec#spec-setup)
                '';
              };

              config.name = lib.mkIf (cfg.pkg != null) (lib.mkDefault "${lib.getName cfg.pkg}");
              config.dir = lib.mkIf (cfg.pkg != null) (lib.mkDefault "${cfg.pkg}");
            }
          )
        );

      lazyPluginsListType = types.listOf lazyPluginType;
    in
    {
      gitPackage = lib.mkPackageOption pkgs "git" { nullable = true; };
      luarocksPackage = lib.mkPackageOption pkgs "luarocks" { nullable = true; };

      plugins = lib.mkOption {
        type = lazyPluginsListType;
        default = [ ];
        description = "List of plugins";
      };
    };

  extraConfig =
    cfg:
    let
      # The `pkg` property isn't a part of the `lazy.nvim` plugin spec, while
      # it shouldn't do any harm but it does take up unnecessary space in the
      # init.lua file. Since we're done using it we will strip it from the
      # final list of specs.
      removePkgAttrFromPlugin =
        plugin:
        builtins.removeAttrs plugin [ "pkg" ]
        // lib.optionalAttrs (((plugin.dependencies or null) != null) && lib.isList plugin.dependencies) {
          dependencies = map removePkgAttrFromPlugin plugin.dependencies;
        };

      removePkgAttrFromPlugins = plugins: map removePkgAttrFromPlugin plugins;
    in
    {
      extraPackages = [
        cfg.gitPackage
        cfg.luarocksPackage
      ];
      plugins.lazy.settings.spec = removePkgAttrFromPlugins cfg.plugins;
    };
}
