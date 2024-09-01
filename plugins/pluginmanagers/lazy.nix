{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim)
    defaultNullOpts
    mkNullOrOption
    mkNullOrLuaFn
    mkNullOrStrLuaFnOr
    ;
  inherit (lib) types;

  # The regex used in this match function matches a string containing two
  # segments separated by a single forward slash ('/'). Each segment is
  # composed of one or more characters that are neither newlines ('\n')
  # nor forward slashes ('/').
  #
  # The pattern ensures that both segments must be non-empty and must not
  # include line breaks or slashes within them.
  isShortGitURL = x: lib.isStringLike x && builtins.match "[^\n/]+/[^\n/]+" (toString x) != null;

  # The regex used in this match function matches any string that starts
  # with either `https://` or `http://`.
  isGitURL = x: lib.isStringLike x && builtins.match "https?://.*" (toString x) != null;

  inherit (config) isDocs;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "lazy";
  originalName = "lazy.nvim";
  package = "lazy-nvim";

  maintainers = with lib.maintainers; [
    MattSturgeon
    my7h3le
  ];

  settingsOptions = with types; {
    git.url_format = defaultNullOpts.mkStr "https://github.com/%s.git" ''
      The default url format that `lazy.nvim` expects short plugin urls to be
      in. (See: upstream docs for `config.git.url_format` defined here
      https://lazy.folke.io/configuration);
    '';

    dev.fallback = defaultNullOpts.mkBool false ''
      When false, `lazy.nvim` won't try to use git to fetch local plugins that
      don't exist.
    '';

    install.missing = defaultNullOpts.mkBool false ''
      When false, `lazy.nvim` won't try to install missing plugins on startup.
      Setting this to true won't increase startup time.
    '';
  };

  extraOptions =
    let
      shortGitURL = lib.mkOptionType {
        name = "shorGitURL";
        description = "a short git url of the form `owner/repo`";
        descriptionClass = "noun";
        check = isShortGitURL;
        merge = lib.mergeEqualOption;
      };

      gitURL = lib.mkOptionType {
        name = "gitURL";
        description = "a git url";
        descriptionClass = "noun";
        check = isGitURL;
        merge = lib.mergeEqualOption;
      };

      lazyPluginSourceType =
        with types;
        oneOf [
          package
          path
          shortGitURL
          gitURL
        ];

      lazyPluginType =
        with types;
        types.coercedTo lazyPluginSourceType (source: { inherit source; }) (
          submodule (
            { config, ... }:

            {
              freeformType = attrsOf anything;
              options = {
                source = mkNullOrOption lazyPluginSourceType ''
                  The `source` attribute can either be one of:

                    - a local plugin directory path.
                    - a full plugin url.
                    - a short plugin url.

                  If a short plugin url is given e.g. "echasnovski/mini.ai"
                  it will be expanded by `lazy.nvim` using
                  `plugins.lazy.settings.git.url_format`
                  ```
                '';

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
                dependencies =
                  let
                    lazyPluginDependenciesType =
                      if isDocs then
                        # Use a stub type for documentation purposes
                        # We don't need to repeat all the plugin-type sub-options again in the docs
                        # It'd also be infinitely recursive
                        lib.mkOptionType {
                          name = "pluginDependencies";
                          description = "plugin submodule";
                          descriptionClass = "noun";
                          check = throw "should not be used";
                          merge = throw "should not be used";
                        }
                      else
                        # NOTE: use attrsOf for the LHS, because coercedTo only supports submodules on the RHS
                        types.coercedTo (either (attrsOf anything) lazyPluginSourceType) lib.toList (listOf lazyPluginType);
                  in
                  mkNullOrOption lazyPluginDependenciesType ''
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
                      source = neorg;
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

              config.name = lib.mkIf (config.source != null) (
                if (lib.isDerivation config.source) then
                  lib.mkDefault "${lib.getName config.source}"
                else
                  lib.mkDefault "${builtins.baseNameOf config.source}"
              );
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

  extraConfig = cfg: {
    extraPackages = [
      cfg.gitPackage
      cfg.luarocksPackage
    ];
    plugins.lazy.settings.spec =
      # The `source` option i.e. `plugins.lazy.plugins.<plugin>.source` is just
      # a convenience nixvim option that makes it easier to specify a plugin
      # source whether it be a:
      #
      #   - nix package
      #   - directory path
      #   - git url
      #   - short git url of the form `owner/repo`
      #
      # and the `source` option itself is not a part of the upstream
      # `lazy.nvim` plugin spec (See: https://lazy.folke.io/spec).
      #
      # As a result the values given to `source` need to be mapped to properties in the
      # upstream `lazy.nvim` plugin spec i.e. ([1]|dir|url). After which the
      # `source` attribute itself will be stripped.
      let
        pluginToSpec =
          plugin:
          lib.concatMapAttrs (
            key: value:
            if key == "source" && value != null then
              {
                dir = if (lib.isDerivation value || lib.isPath value) then "${value}" else null;
                __unkeyed = if (isShortGitURL value) then value else null;
                url = if (isGitURL value) then value else null;
              }
            #
            # If a plugin has a custom `name` but no `source`, it suggests that
            # the plugin might be defined elsewhere in the plugin list or as
            # part of another plugin (e.g. a Neovim distribution like LazyVim).
            #
            # In these cases, a custom `name` can be used instead of `source`
            # and the plugin spec options given will be applied or merged with
            # the original plugin definition. This is particularly useful for
            # plugins that bundle multiple modules (e.g. mini-nvim, which
            # includes mini-ai, mini-trailspace, etc.), where you need to
            # modify options for individual modules without affecting the
            # entire bundle.
            #
            # To achieve this, we map `name` to `__unkeyed` (which corresponds
            # to `[1]` in `lazy.nvim`).
            #
            else if (key == "name" && value != null) && ((plugin.source or null) == null) then
              { __unkeyed = value; }
            else if key == "dependencies" && value != null then
              { dependencies = map pluginToSpec value; }
            else
              { "${key}" = value; }
          ) plugin;

      in
      map pluginToSpec cfg.plugins;
  };
}
