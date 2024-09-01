# TODO: add function (_, opts) docs
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim)
    defaultNullOpts
    keymaps
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
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lazy";
  packPathName = "lazy.nvim";
  package = "lazy-nvim";

  # TODO: added 2025-04-06, remove after 25.05
  imports = [
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "lazy";
      packageName = "git";
    })
  ];

  maintainers = with lib.maintainers; [
    MattSturgeon
    my7h3le
  ];

  settingsOptions = {
    # TODO: check and maybe reword this description
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
    with types;
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

      lazyPluginSourceType = oneOf [
        package
        path
        shortGitURL
        gitURL
      ];

      lazyPluginType = coercedTo lazyPluginSourceType (source: { inherit source; }) (
        submodule (
          { config, ... }:

          {
            freeformType = attrsOf anything;
            options = {
              source = mkNullOrOption lazyPluginSourceType ''
                The `source` option i.e. `plugins.lazy.plugins.<plugin>.source` is just
                a convenience nixvim option that makes it easier to specify a plugin
                source whether it be a:

                  - nix package
                  - directory path
                  - git url
                  - short git url of the form `owner/repo`

                and the `source` option itself is not a part of the upstream
                `lazy.nvim` plugin spec (See: https://lazy.folke.io/spec).

                As a result the values given to `source` need to be mapped to
                properties in the upstream `lazy.nvim` plugin spec i.e.
                ([1]|dir|url). After which the `source` attribute itself will
                be stripped from the final lua config.
                ```
              '';

              # TODO: rework 3rd paragraph of this, make sure you add the fact
              # that with custom name it has to be defined somewhere else in
              # the list
              name = mkNullOrOption str ''
                A custom name for the plugin used for the local plugin
                directory and as the display name. By default nixvim will set
                a default value for this depending on what was specified to
                `plugins.lazy.plugins.<plugin>.source`, namely if a nix package
                was given to `plugins.lazy.plugins.<plugin>.source` then name
                will default to the nix package's name, and if a git url or a
                short git url was specified, then name will default to the base
                name of that url.

                It is also worth mentioning that a plugin can have the option
                `plugins.lazy.plugins.<plugin>.name` defined but not have
                `plugins.lazy.plugins.<plugin>.source` defined.

                In these cases, a custom `name` can be used instead of `source`
                and the plugin spec options given will be applied or merged with
                the original plugin definition. This is particularly useful for
                plugins that bundle multiple modules (e.g. mini-nvim, which
                includes mini-ai, mini-trailspace, etc.), where you need to
                modify options for individual modules without affecting the
                entire bundle.
              '';

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
                Behaves the same as `plugins.lazy.plugins.<plugin>.enabled`,
                but won't uninstall the plugin when the condition is false.
                Useful to disable some plugins in vscode, or firenvim for
                example. 

                Note: Since out of tree non nix package plugins are only ever
                uninstalled by `lazy.nvim`, this option as far as nix package
                plugins are concerned, only serves the same purpose as
                `plugins.lazy.plugins.<plugin>.enabled`.
              '';

              # WARNING: Be very careful if changing the type of
              # `dependencies`. Choosing the wrong type may cause a stack
              # overflow due to infinite recursion, and it's very possible that
              # the test cases won't catch this problem. To be safe, perform
              # thorough manual testing if you do change the type of
              # `dependencies`.
              dependencies =
                let
                  lazyPluginDependenciesType =
                    if isDocs then
                      # Use a stub type for documentation purposes We don't
                      # need to repeat all the plugin-type sub-options again in
                      # the docs It'd also be infinitely recursive
                      lib.mkOptionType {
                        name = "pluginDependencies";
                        description = "plugin submodule";
                        descriptionClass = "noun";
                        check = throw "should not be used";
                        merge = throw "should not be used";
                      }
                    else
                      # NOTE: use attrsOf for the LHS, because coercedTo only supports submodules on the RHS
                      coercedTo (either (attrsOf anything) lazyPluginSourceType) lib.toList (listOf lazyPluginType);
                in
                mkNullOrOption lazyPluginDependenciesType ''
                  In terms of setting values to this option it is effectively
                  the same as `plugins.lazy.plugins`, with the following
                  additions in terms of what it can be:

                    - It can also be single string such as for a custom plugin
                      name e.g. `dependencies = "nvim-treesitter";`


                      If it is just a custom name however, then the plugin spec
                      must be defined somewhere else in the list given to
                      `plugins.lazy.plugins`. For example:

                      ```Nix
                        {
                          plugins.lazy.plugins = with pkgs.vimPlugins; [
                            {

                              # Only a custom name was given to
                              # `plugins.lazy.plugins.<plugin>.dependencies`,
                              # therefore a plugin spec with this name must be
                              # defined somewhere else in the list given to
                              # `plugins.lazy.plugins`.
                              source = nvim-treesitter-textobjects;
                              dependencies = "nvim-treesitter";
                            }

                            # We define the plugin spec with name "nvim-treesitter"
                            # here:
                            {
                              source = nvim-treesitter;

                              # Note: By default if a nix package is given to
                              # `plugins.lazy.plugins.<plugin>.source`, then the
                              # `name` option will have have a default value of
                              # that nix package's name. So in this example the
                              # custom name of "nvim-treesitter" doesn't need to
                              # be explicitly set here as the nix package
                              # `pkgs.vimPlugins.nvim-treesitter` name attribute
                              # is already "nvim-treesitter".
                              name = "nvim-treesitter";

                              opts = {
                                highlight = {
                                  enable = true;
                                };
                                ensure_installed = [
                                  "vim"
                                  "regex"
                                  "lua"
                                  "bash"
                                  "markdown"
                                  "angular"
                                  "markdown_inline"
                                  "hyprlang"
                                ];
                                parser_install_dir.__raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'site')";
                              };
                            }
                          ];
                        }
                      ```

                    - A single nix plugin package (e.g. `dependencies = pkgs.vimPlugins.nvim-treesitter;`)

                  Outside of these additions, what it can be set to is
                  effectively the same as `plugins.lazy.plugins` i.e. A list of
                  nix plugin packages and or attribute sets denoting plugin
                  specs that should be loaded, and loaded before the current
                  plugin loads. Dependencies are always lazy-loaded unless
                  specified otherwise. When specifying a name, make sure the
                  plugin spec has been defined somewhere else. (See:
                  https://lazy.folke.io/spec). 
                '';

              init = mkNullOrLuaFn ''
                Functions that are always executed during startup. Mostly
                useful for setting vim.g.* configuration used by Vim plugins
                startup.
              '';

              config = mkNullOrStrLuaFnOr (enum [ true ]) ''
                A lua function with signature `fun(LazyPlugin, opts:table)`
                that gets executed when the plugin loads. It can also just be
                a `true` boolean.

                The default implementation will automatically run
                `require(MAIN).setup(opts)` if
                `plugins.lazy.plugins.<plugin>.opts` is set or if `config`
                itself is set to `true`. Lazy uses several heuristics to
                determine the plugin's MAIN module automatically based on the
                plugin's name. (`plugins.lazy.plugins.<plugin>.opts` is the
                recommend way to configure plugins).
              '';

              main = mkNullOrOption str ''
                You can specify the main module to use for
                `plugins.lazy.plugins.<plugin>.config` and
                `plugins.lazy.plugins.<plugin>.opts`, in case it can not be
                determined automatically.

                See `plugins.lazy.plugins.<plugin>.config`.
              '';

              submodules = defaultNullOpts.mkBool true ''
                When `false`, git submodules will not be fetched. Defaults to `true`
              '';

              event = mkNullOrOption (maybeRaw (either str (listOf str))) ''
                Lazy-load on event. Events can be specified as `BufEnter`, a
                pattern like `BufEnter *.lua` or a list of events `event = [
                "BufRead" "BufEnter" ];`. It can also be a lua function of
                signature `fun(self:LazyPlugin, event:string[])` that returns a
                list of strings.

                See https://neovim.io/doc/user/autocmd.html for a more info neovim events.
                Also see upstream `lazy.nvim` docs at https://lazy.folke.io/spec
              '';

              cmd = mkNullOrOption (maybeRaw (either str (listOf str))) ''
                Lazy-load on command. Commands can be specified as a single
                string like `StartupTime` or a list of strings to lazy load the
                plugin on any given command. This can also be a lua function that
                returns a list of strings.

                Example:

                ```Nix
                  {
                    plugins.lazy.plugins = with pkgs.vimPlugins; [
                      {
                        source = vim-startuptime;
                        # Lazy load plugin when `StartupTime` command is invoked.
                        cmd = "StartupTime";
                      }
                    ];
                  }
                ```
              '';

              ft = mkNullOrOption (maybeRaw (either str (listOf str))) ''
                Lazy-load plugin only on a given filetype/filetypes e.g.:

                ```Nix
                plugins.lazy.plugins = with pkgs.vimPlugins; [
                  {
                    source = neorg;
                    # Only load plugin on "norg" filetyes
                    # Note: this can also be a list as well (i.e. `ft = [ "norg" ];`)
                    ft = "norg";
                    opts = {
                      load."['core.defaults']" = [ ];
                    };
                  }
                ];
                ```

                Can also be a lua function that returns a list of strings, that
                denote filetyes. Example:

                ```Nix
                plugins.lazy.plugins = with pkgs.vimPlugins; [
                  {
                    source = neorg;
                    # Can also be a function that returns a list of filetypes
                    ft = "function() return { "norg" } end"
                    opts = {
                      load."['core.defaults']" = [ ];
                    };
                  }
                ];
                ```
              '';

              # TODO: add better description here
              keys = mkNullOrOption (listOf (
                keymaps.mkMapOptionSubmodule {
                  defaults = {
                    mode = "n";
                  };
                  # HACK: with how `mkMapOptionSubmodule` is currently
                  # defined, mode will keep being set to default value
                  # denoted by `defaults.mode`, and the user can not override
                  # it without this workaround.
                  extraOptions = {
                    mode = keymaps.mkModeOption "n";
                    action = mkNullOrOption (maybeRaw str) ''
                      The action to execute.
                    '';
                    ft = mkNullOrOption (either (maybeRaw str) (listOf (maybeRaw str))) ''
                      Make the keybind trigger for only certain file type/s.
                    '';
                  };
                }
              )) "Lazy-load on key mapping";

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

                - An attribute set: The equivalent of this in lua would be a
                table. This options defined in this attribute set will be
                merged with any existing configuration settings from the parent
                specification of the plugin.

                - A function that returns a table: The returned table will
                completely replace any existing configuration settings from
                the plugin's parent specifications.

                - A function that modifies a table: This function will
                receive the existing configuration table as an argument and
                can modify it directly.

                In all cases, the resulting configuration table will be passed
                to the `plugins.lazy.plugins.<plugin>.config` function. Setting
                the opts value automatically implies that the
                `plugins.lazy.plugins.<plugin>.config` function will be called.
                (See: https://lazy.folke.io/spec#spec-setup)
              '';
            };

            # Set the name of a plugin by default. This is mostly for
            # convenience as it avoids long nix store paths be shown as the
            # display names when running `:Lazy`.
            config.name = lib.mkIf (config.source != null) (
              if (lib.isDerivation config.source) then
                lib.mkDefault "${lib.getName config.source}"
              else
                lib.mkDefault "${builtins.baseNameOf config.source}"
            );
          }
        )
      );

      lazyPluginsListType = listOf lazyPluginType;
    in
    {
      luarocksPackage = lib.mkPackageOption pkgs "luarocks" { nullable = true; };

      plugins = lib.mkOption {
        type = lazyPluginsListType;
        default = [ ];
        description = "List of plugins";
      };
    };

  extraConfig = cfg: {
    dependencies.git.enable = lib.mkDefault true;

    extraPackages = [
      cfg.luarocksPackage
    ];
    plugins.lazy.settings.spec =
      let
        convertToLazyKeyMappingType =
          km:
          {
            __unkeyed-1 = km.key;
          }
          // lib.optionalAttrs (lib.hasAttr "action" km) { __unkeyed-2 = km.action; }
          // lib.optionalAttrs (lib.hasAttr "mode" km) { inherit (km) mode; }
          // lib.optionalAttrs (lib.hasAttr "ft" km) { inherit (km) ft; }
          // lib.removeAttrs km [
            "action"
            "mode"
            "ft"
          ];

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
            else if (key == "name" && value != null) && ((plugin.source or null) == null) then
              { __unkeyed = value; }
            else if key == "dependencies" && value != null then
              { dependencies = map pluginToSpec value; }
            # If the user explicitly sets the 'dir' option, use the provided
            # value instead of an extrapolated default.
            else if (key == "dir" && value != null) then
              { dir = value; }
            # If the user explicitly sets the 'url' option, use the provided
            # value instead of an extrapolated default.
            else if (key == "url" && value != null) then
              { url = value; }
            # If the 'keys' option is given, we need to explicitly convert that into a form that `lazy.nvim` expects.
            else if (key == "keys" && value != null) then
              { keys = map convertToLazyKeyMappingType value; }
            # Preserve all other key value pair mappings, this also handles
            # freeform options.
            else
              { "${key}" = value; }
          ) plugin;
      in
      map pluginToSpec cfg.plugins;
  };
}
