{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.lsp.servers.pylsp;
in {
  # All settings are documented here:
  # https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md

  options.plugins.lsp.servers.pylsp.settings = {
    configurationSources = mkOption {
      type = lib.types.nullOr (types.enum ["pycodestyle" "flake8"]);
      description = "List of configuration sources to use.";
      default = null;
      apply = value:
        if (value != null)
        then [value]
        else null;
    };

    plugins = {
      autopep8 = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin (autopep8).
        '';
      };

      flake8 = {
        config = helpers.mkNullOrOption types.str ''
          Path to the config file that will be the authoritative config source.
        '';

        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin (flake8).
        '';

        exclude = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          List of files or directories to exclude.
        '';

        executable = helpers.mkNullOrOption types.str ''
          Path to the flake8 executable.
        '';

        filename = helpers.mkNullOrOption types.str ''
          Only check for filenames matching the patterns in this list.
        '';

        hangClosing = helpers.mkNullOrOption types.bool ''
          Hang closing bracket instead of matching indentation of opening bracket's line.
        '';

        ignore = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          List of errors and warnings to ignore (or skip).
        '';

        maxComplexity = helpers.mkNullOrOption types.int ''
          Maximum allowed complexity threshold.
        '';

        maxLineLength = helpers.mkNullOrOption types.int ''
          Maximum allowed line length for the entirety of this run.
        '';

        indentSize = helpers.mkNullOrOption types.int ''
          Set indentation spaces.
        '';

        perFileIgnores = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          A pairing of filenames and violation codes that defines which violations to ignore in a
          particular file.

          For example: `["file_path.py:W305,W304"]`.
        '';

        select = helpers.mkNullOrOption (types.listOf types.str) ''
          List of errors and warnings to enable.
        '';
      };

      jedi = {
        auto_import_modules =
          helpers.defaultNullOpts.mkNullable
          (types.listOf types.str)
          "[ \"numpy\" ]"
          "List of module names for `jedi.settings.auto_import_modules`.";

        extra_paths = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          Define extra paths for jedi.Script.
        '';

        environment = helpers.mkNullOrOption types.str ''
          Define environment for jedi.Script and Jedi.names.
        '';
      };

      jedi_completion = {
        enabled = helpers.defaultNullOpts.mkBool true "Enable or disable the plugin.";

        include_params = helpers.defaultNullOpts.mkBool true ''
          Auto-completes methods and classes with tabstops for each parameter.
        '';

        include_class_objects = helpers.defaultNullOpts.mkBool false ''
          Adds class objects as a separate completion item.
        '';

        include_function_objects = helpers.defaultNullOpts.mkBool false ''
          Adds function objects as a separate completion item.
        '';

        fuzzy = helpers.defaultNullOpts.mkBool false ''
          Enable fuzzy when requesting autocomplete.
        '';

        eager = helpers.defaultNullOpts.mkBool false ''
          Resolve documentation and detail eagerly.
        '';

        resolve_at_most = helpers.defaultNullOpts.mkInt 25 ''
          How many labels and snippets (at most) should be resolved.
        '';

        cache_for =
          helpers.defaultNullOpts.mkNullable
          (types.listOf types.str)
          "[ \"pandas\" \"numpy\" \"tensorflow\" \"matplotlib\" ]"
          "Modules for which labels and snippets should be cached.";
      };

      jedi_definition = {
        enabled = helpers.defaultNullOpts.mkBool true "Enable or disable the plugin.";

        follow_imports = helpers.defaultNullOpts.mkBool true ''
          The goto call will follow imports.
        '';

        follow_builtin_imports = helpers.defaultNullOpts.mkBool true ''
          If follow_imports is true will decide if it follow builtin imports.
        '';

        follow_builtin_definitions = helpers.defaultNullOpts.mkBool true ''
          Follow builtin and extension definitions to stubs.
        '';
      };

      jedi_hover = {
        enabled = helpers.defaultNullOpts.mkBool true "Enable or disable the plugin.";
      };

      jedi_references = {
        enabled = helpers.defaultNullOpts.mkBool true "Enable or disable the plugin.";
      };

      jedi_signature_help = {
        enabled = helpers.defaultNullOpts.mkBool true "Enable or disable the plugin.";
      };

      jedi_symbols = {
        enabled = helpers.defaultNullOpts.mkBool true "Enable or disable the plugin.";

        all_scopes = helpers.defaultNullOpts.mkBool true ''
          If true lists the names of all scopes instead of only the module namespace.
        '';

        include_import_symbols = helpers.defaultNullOpts.mkBool true ''
          If true includes symbols imported from other libraries.
        '';
      };

      mccabe = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin (mccabe).
        '';

        threshold = helpers.defaultNullOpts.mkInt 15 ''
          The minimum threshold that triggers warnings about cyclomatic complexity.
        '';
      };

      preload = {
        enabled = helpers.defaultNullOpts.mkBool true "Enable or disable the plugin.";

        modules = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          List of modules to import on startup.
        '';
      };

      pycodestyle = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin
          (pycodestyle).
        '';

        exclude = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          Exclude files or directories which match these patterns.
        '';

        filename = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          When parsing directories, only check filenames matching these patterns.
        '';

        ropeFolder = helpers.mkNullOrOption (types.listOf types.str) ''
          Select errors and warnings.
        '';

        ignore = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          Ignore errors and warnings.
        '';

        hangClosing = helpers.mkNullOrOption types.bool ''
          Hang closing bracket instead of matching indentation of opening bracket's line.
        '';

        maxLineLength = helpers.mkNullOrOption types.int ''
          Set maximum allowed line length.
        '';

        indentSize = helpers.mkNullOrOption types.int ''
          Set indentation spaces.
        '';
      };

      pydocstyle = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin
          (pydocstyle).
        '';

        convention =
          helpers.mkNullOrOption
          (types.enum [
            "pep257"
            "numpy"
            "google"
            "None"
          ])
          "Choose the basic list of checked errors by specifying an existing convention.";

        addIgnore = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          Ignore errors and warnings in addition to the specified convention.
        '';

        addSelect = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          Select errors and warnings in addition to the specified convention.
        '';

        ignore = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          Ignore errors and warnings.
        '';

        select = helpers.mkNullOrOption (types.listOf types.str) ''
          Select errors and warnings.
        '';

        match = helpers.defaultNullOpts.mkStr "(?!test_).*\\.py" ''
          Check only files that exactly match the given regular expression;
          default is to match files that don't start with 'test_' but end with '.py'.
        '';

        matchDir = helpers.defaultNullOpts.mkStr "[^\\.].*" ''
          Search only dirs that exactly match the given regular expression;
          default is to match dirs which do not begin with a dot.
        '';
      };

      pyflakes = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin (pyflakes).
        '';
      };

      pylint = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin (pylint).
        '';

        args = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          Arguments to pass to pylint.
        '';

        executable = helpers.mkNullOrOption types.str ''
          Executable to run pylint with.
          Enabling this will run pylint on unsaved files via stdin.
          Can slow down workflow. Only works with python3.
        '';
      };

      rope_autoimport = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin (rope).
        '';

        memory = helpers.defaultNullOpts.mkBool false ''
          Make the autoimport database memory only.
          Drastically increases startup time.
        '';
      };

      rope_completion = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin (rope).
        '';

        eager = helpers.defaultNullOpts.mkBool false ''
          Resolve documentation and detail eagerly.
        '';
      };

      yapf = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin (yapf).
        '';
      };

      ### THIRD-PARTY PLUGINS
      pylsp_mypy = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin
          (pylsp-mypy).
        '';

        live_mode = helpers.defaultNullOpts.mkBool true ''
          Provides type checking as you type.
          This writes to a tempfile every time a check is done.
          Turning off live_mode means you must save your changes for mypy diagnostics to update
          correctly.
        '';

        dmypy = helpers.defaultNullOpts.mkBool false ''
          Executes via dmypy run rather than mypy.
          This uses the dmypy daemon and may dramatically improve the responsiveness of the pylsp
          server, however this currently does not work in live_mode.
          Enabling this disables live_mode, even for conflicting configs.
        '';

        strict = helpers.defaultNullOpts.mkBool false ''
          Refers to the strict option of mypy.
          This option often is too strict to be useful.
        '';

        overrides =
          helpers.defaultNullOpts.mkNullable
          (with types; listOf (either bool str))
          "[true]"
          ''
            Specifies a list of alternate or supplemental command-line options.
            This modifies the options passed to mypy or the mypy-specific ones passed to dmypy run.
            When present, the special boolean member true is replaced with the command-line options that
            would've been passed had overrides not been specified.
            Later options take precedence, which allows for replacing or negating individual default
            options (see mypy.main:process_options and mypy --help | grep inverse).
          '';

        dmypy_status_file = helpers.defaultNullOpts.mkStr ".dmypy.json" ''
          Specifies which status file dmypy should use.
          This modifies the --status-file option passed to dmypy given dmypy is active.
        '';

        config_sub_paths = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          Specifies sub paths under which the mypy configuration file may be found.
          For each directory searched for the mypy config file, this also searches the sub paths
          specified here.
        '';

        report_progress = helpers.defaultNullOpts.mkBool false ''
          Report basic progress to the LSP client.
          With this option, pylsp-mypy will report when mypy is running, given your editor supports
          LSP progress reporting.
          For small files this might produce annoying flashing in your editor, especially in with
          live_mode.
          For large projects, enabling this can be helpful to assure yourself whether mypy is still
          running.
        '';
      };

      isort = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin
          (pyls-isort).
        '';
      };

      black = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin
          (python-lsp-black).
        '';

        cache_config = helpers.defaultNullOpts.mkBool false ''
          Whether to enable black configuration caching.
        '';

        line_length = helpers.defaultNullOpts.mkInt 88 ''
          An integer that maps to black's max-line-length setting.
          Defaults to 88 (same as black's default).
          This can also be set through black's configuration files, which should be preferred for
          multi-user projects.
        '';

        preview = helpers.defaultNullOpts.mkBool false ''
          Enable or disable black's --preview setting.
        '';
      };

      memestra = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin
          (pyls-memestra).
        '';
      };

      rope = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin
          (pylsp-rope).
        '';
      };

      ruff = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Enable or disable the plugin.
          Setting this explicitely to `true` will install the dependency for this plugin
          (python-lsp-ruff).
        '';

        config = helpers.mkNullOrOption types.str "Path to optional pyproject.toml file.";

        exclude = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
          Exclude files from being checked by ruff.
        '';

        executable = helpers.mkNullOrOption types.str ''
          Path to the ruff executable. Assumed to be in PATH by default.
        '';

        ignore = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
          Error codes to ignore.
        '';

        extendIgnore = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
          Same as ignore, but append to existing ignores.
        '';

        lineLength = helpers.mkNullOrOption types.int "Set the line-length for length checks.";

        perFileIgnores = helpers.mkNullOrOption (with types; attrsOf (listOf str)) ''
          File-specific error codes to be ignored.
        '';

        select = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
          List of error codes to enable.
        '';

        extendSelect = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
          Same as select, but append to existing error codes.
        '';

        format = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
          List of error codes to fix during formatting.
          The default is ["I"], any additional codes are appended to this list.
        '';
      };

      ### END OF THIRD-PARTY PLUGINS
    };

    rope = {
      extensionModules = helpers.mkNullOrOption types.str ''
        Builtin and c-extension modules that are allowed to be imported and inspected by rope.
      '';

      ropeFolder = helpers.mkNullOrOption (types.listOf types.str) ''
        The name of the folder in which rope stores project configurations and data.
        Pass null for not using such a folder at all.
      '';
    };
  };

  config =
    mkIf cfg.enable
    {
      # WARNING: tricky stuff below:
      # We need to fix the `python-lsp-server` derivation by adding all of the (user enabled)
      # plugins to its `propagatedBuildInputs`.
      # See https://github.com/NixOS/nixpkgs/issues/229337
      plugins.lsp.servers.pylsp.package = let
        isEnabled = x: (x.enabled != null && x.enabled);
        inherit (cfg.settings) plugins;

        nativePlugins =
          (map
            (
              pluginName: (
                optionals (isEnabled plugins.${pluginName})
                cfg.package.optional-dependencies.${pluginName}
              )
            )
            [
              "autopep8"
              "flake8"
              "mccabe"
              "pycodestyle"
              "pydocstyle"
              "pyflakes"
              "pylint"
              "yapf"
            ])
          ++ (
            optionals
            (
              (isEnabled plugins.rope_autoimport)
              || (isEnabled plugins.rope_completion)
            )
            cfg.package.optional-dependencies.rope
          );

        # All of those plugins have `python-lsp-server` as a dependency.
        # We need to get rid of it to add them to the `python-lsp-server` derivation itself.
        thirdPartyPlugins = lists.flatten (
          mapAttrsToList
          (
            pluginName: nixPackage: (
              optional
              (isEnabled plugins.${pluginName})
              (
                nixPackage.overridePythonAttrs (
                  old: {
                    # Get rid of the python-lsp-server dependency
                    propagatedBuildInputs =
                      filter
                      (dep: dep.pname != "python-lsp-server")
                      old.propagatedBuildInputs;

                    # Skip testing because those naked dependencies will complain about missing pylsp
                    doCheck = false;
                  }
                )
              )
            )
          )
          (with pkgs.python3Packages; {
            pylsp_mypy = pylsp-mypy.overridePythonAttrs (old: {
              postPatch =
                old.postPatch
                or ''''
                + ''
                  substituteInPlace setup.cfg \
                    --replace "python-lsp-server >=1.7.0" ""
                '';
            });
            isort = pyls-isort.overridePythonAttrs (old: {
              postPatch =
                old.postPatch
                or ''''
                + ''
                  substituteInPlace setup.py \
                    --replace 'install_requires=["python-lsp-server", "isort"],' 'install_requires=["isort"],'
                '';
            });
            black = python-lsp-black.overridePythonAttrs (old: {
              postPatch =
                old.postPatch
                or ''''
                + ''
                  substituteInPlace setup.cfg \
                    --replace "python-lsp-server>=1.4.0" ""
                '';
            });
            memestra = pyls-memestra.overridePythonAttrs (old: {
              postPatch =
                old.postPatch
                or ''''
                + ''
                  sed -i '/python-lsp-server/d' requirements.txt
                '';
            });
            rope = pylsp-rope.overridePythonAttrs (old: {
              postPatch =
                old.postPatch
                or ''''
                + ''
                  sed -i '/python-lsp-server/d' setup.cfg
                '';
            });
            ruff = python-lsp-ruff.overridePythonAttrs (old: {
              postPatch =
                old.postPatch
                or ''''
                + ''
                  sed -i '/python-lsp-server/d' pyproject.toml
                '';

              nativeBuildInputs = [setuptools] ++ (old.nativeBuildInputs or []);
            });
          })
        );

        # Final list of pylsp plugins to install
        pylspPlugins = nativePlugins ++ thirdPartyPlugins;
      in
        mkDefault (
          # This is the final default package for pylsp
          pkgs.python3Packages.python-lsp-server.overridePythonAttrs (
            old: {
              propagatedBuildInputs = pylspPlugins ++ old.propagatedBuildInputs;
              disabledTests =
                (old.disabledTests or [])
                ++ [
                  # Those tests fail when third-party plugins are loaded
                  "test_notebook_document__did_open"
                  "test_notebook_document__did_change"
                ];
            }
          )
        );
    };
}
