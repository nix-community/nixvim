{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.plugins.lsp.servers.pylsp;
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
  inherit (lib) mkOption types;
in
{
  options.plugins.lsp.servers.pylsp = {
    pythonPackage = lib.mkPackageOption pkgs "python" {
      default = "python3";
    };

    # All settings are documented here:
    # https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    settings = {
      configurationSources = mkOption {
        type = types.nullOr (
          types.enum [
            "pycodestyle"
            "flake8"
          ]
        );
        description = "List of configuration sources to use.";
        default = null;
        apply = value: if (value != null) then [ value ] else null;
      };

      plugins = {
        autopep8 = {
          enabled = defaultNullOpts.mkBool true ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin (autopep8).
          '';
        };

        flake8 = {
          config = mkNullOrOption types.str ''
            Path to the config file that will be the authoritative config source.
          '';

          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin (flake8).
          '';

          exclude = defaultNullOpts.mkListOf types.str [ ] ''
            List of files or directories to exclude.
          '';

          executable = mkNullOrOption types.str ''
            Path to the flake8 executable.
          '';

          filename = mkNullOrOption types.str ''
            Only check for filenames matching the patterns in this list.
          '';

          hangClosing = mkNullOrOption types.bool ''
            Hang closing bracket instead of matching indentation of opening bracket's line.
          '';

          ignore = defaultNullOpts.mkListOf types.str [ ] ''
            List of errors and warnings to ignore (or skip).
          '';

          maxComplexity = mkNullOrOption types.int ''
            Maximum allowed complexity threshold.
          '';

          maxLineLength = mkNullOrOption types.int ''
            Maximum allowed line length for the entirety of this run.
          '';

          indentSize = mkNullOrOption types.int ''
            Set indentation spaces.
          '';

          perFileIgnores = defaultNullOpts.mkListOf types.str [ ] ''
            A pairing of filenames and violation codes that defines which violations to ignore in a
            particular file.

            For example: `["file_path.py:W305,W304"]`.
          '';

          select = mkNullOrOption (types.listOf types.str) ''
            List of errors and warnings to enable.
          '';
        };

        jedi = {
          auto_import_modules = defaultNullOpts.mkListOf types.str [
            "numpy"
          ] "List of module names for `jedi.settings.auto_import_modules`.";

          extra_paths = defaultNullOpts.mkListOf types.str [ ] ''
            Define extra paths for jedi.Script.
          '';

          environment = mkNullOrOption types.str ''
            Define environment for jedi.Script and Jedi.names.
          '';
        };

        jedi_completion = {
          enabled = defaultNullOpts.mkBool true "Enable or disable the plugin.";

          include_params = defaultNullOpts.mkBool true ''
            Auto-completes methods and classes with tabstops for each parameter.
          '';

          include_class_objects = defaultNullOpts.mkBool false ''
            Adds class objects as a separate completion item.
          '';

          include_function_objects = defaultNullOpts.mkBool false ''
            Adds function objects as a separate completion item.
          '';

          fuzzy = defaultNullOpts.mkBool false ''
            Enable fuzzy when requesting autocomplete.
          '';

          eager = defaultNullOpts.mkBool false ''
            Resolve documentation and detail eagerly.
          '';

          resolve_at_most = defaultNullOpts.mkInt 25 ''
            How many labels and snippets (at most) should be resolved.
          '';

          cache_for = defaultNullOpts.mkListOf types.str [
            "pandas"
            "numpy"
            "tensorflow"
            "matplotlib"
          ] "Modules for which labels and snippets should be cached.";
        };

        jedi_definition = {
          enabled = defaultNullOpts.mkBool true "Enable or disable the plugin.";

          follow_imports = defaultNullOpts.mkBool true ''
            The goto call will follow imports.
          '';

          follow_builtin_imports = defaultNullOpts.mkBool true ''
            If follow_imports is true will decide if it follow builtin imports.
          '';

          follow_builtin_definitions = defaultNullOpts.mkBool true ''
            Follow builtin and extension definitions to stubs.
          '';
        };

        jedi_hover = {
          enabled = defaultNullOpts.mkBool true "Enable or disable the plugin.";
        };

        jedi_references = {
          enabled = defaultNullOpts.mkBool true "Enable or disable the plugin.";
        };

        jedi_signature_help = {
          enabled = defaultNullOpts.mkBool true "Enable or disable the plugin.";
        };

        jedi_symbols = {
          enabled = defaultNullOpts.mkBool true "Enable or disable the plugin.";

          all_scopes = defaultNullOpts.mkBool true ''
            If true lists the names of all scopes instead of only the module namespace.
          '';

          include_import_symbols = defaultNullOpts.mkBool true ''
            If true includes symbols imported from other libraries.
          '';
        };

        mccabe = {
          enabled = defaultNullOpts.mkBool true ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin (mccabe).
          '';

          threshold = defaultNullOpts.mkInt 15 ''
            The minimum threshold that triggers warnings about cyclomatic complexity.
          '';
        };

        preload = {
          enabled = defaultNullOpts.mkBool true "Enable or disable the plugin.";

          modules = defaultNullOpts.mkListOf types.str [ ] ''
            List of modules to import on startup.
          '';
        };

        pycodestyle = {
          enabled = defaultNullOpts.mkBool true ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin
            (pycodestyle).
          '';

          exclude = defaultNullOpts.mkListOf types.str [ ] ''
            Exclude files or directories which match these patterns.
          '';

          filename = defaultNullOpts.mkListOf types.str [ ] ''
            When parsing directories, only check filenames matching these patterns.
          '';

          ropeFolder = mkNullOrOption (types.listOf types.str) ''
            Select errors and warnings.
          '';

          ignore = defaultNullOpts.mkListOf types.str [ ] ''
            Ignore errors and warnings.
          '';

          hangClosing = mkNullOrOption types.bool ''
            Hang closing bracket instead of matching indentation of opening bracket's line.
          '';

          maxLineLength = mkNullOrOption types.int ''
            Set maximum allowed line length.
          '';

          indentSize = mkNullOrOption types.int ''
            Set indentation spaces.
          '';
        };

        pydocstyle = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin
            (pydocstyle).
          '';

          convention = mkNullOrOption (types.enum [
            "pep257"
            "numpy"
            "google"
            "None"
          ]) "Choose the basic list of checked errors by specifying an existing convention.";

          addIgnore = defaultNullOpts.mkListOf types.str [ ] ''
            Ignore errors and warnings in addition to the specified convention.
          '';

          addSelect = defaultNullOpts.mkListOf types.str [ ] ''
            Select errors and warnings in addition to the specified convention.
          '';

          ignore = defaultNullOpts.mkListOf types.str [ ] ''
            Ignore errors and warnings.
          '';

          select = mkNullOrOption (types.listOf types.str) ''
            Select errors and warnings.
          '';

          match = defaultNullOpts.mkStr "(?!test_).*\\.py" ''
            Check only files that exactly match the given regular expression;
            default is to match files that don't start with 'test_' but end with '.py'.
          '';

          matchDir = defaultNullOpts.mkStr "[^\\.].*" ''
            Search only dirs that exactly match the given regular expression;
            default is to match dirs which do not begin with a dot.
          '';
        };

        pyflakes = {
          enabled = defaultNullOpts.mkBool true ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin (pyflakes).
          '';
        };

        pylint = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin (pylint).
          '';

          args = defaultNullOpts.mkListOf types.str [ ] ''
            Arguments to pass to pylint.
          '';

          executable = mkNullOrOption types.str ''
            Executable to run pylint with.
            Enabling this will run pylint on unsaved files via stdin.
            Can slow down workflow. Only works with python3.
          '';
        };

        rope_autoimport = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin (rope).
          '';

          memory = defaultNullOpts.mkBool false ''
            Make the autoimport database memory only.
            Drastically increases startup time.
          '';
        };

        rope_completion = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin (rope).
          '';

          eager = defaultNullOpts.mkBool false ''
            Resolve documentation and detail eagerly.
          '';
        };

        yapf = {
          enabled = defaultNullOpts.mkBool true ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin (yapf).
          '';
        };

        ### THIRD-PARTY PLUGINS
        pylsp_mypy = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin
            (pylsp-mypy).
          '';

          live_mode = defaultNullOpts.mkBool true ''
            Provides type checking as you type.
            This writes to a tempfile every time a check is done.
            Turning off live_mode means you must save your changes for mypy diagnostics to update
            correctly.
          '';

          dmypy = defaultNullOpts.mkBool false ''
            Executes via dmypy run rather than mypy.
            This uses the dmypy daemon and may dramatically improve the responsiveness of the pylsp
            server, however this currently does not work in live_mode.
            Enabling this disables live_mode, even for conflicting configs.
          '';

          strict = defaultNullOpts.mkBool false ''
            Refers to the strict option of mypy.
            This option often is too strict to be useful.
          '';

          overrides = defaultNullOpts.mkListOf (with types; either bool str) [ true ] ''
            Specifies a list of alternate or supplemental command-line options.
            This modifies the options passed to mypy or the mypy-specific ones passed to dmypy run.
            When present, the special boolean member true is replaced with the command-line options that
            would've been passed had overrides not been specified.
            Later options take precedence, which allows for replacing or negating individual default
            options (see `mypy.main:process_options` and `mypy --help | grep inverse`).
          '';

          dmypy_status_file = defaultNullOpts.mkStr ".dmypy.json" ''
            Specifies which status file dmypy should use.
            This modifies the --status-file option passed to dmypy given dmypy is active.
          '';

          config_sub_paths = defaultNullOpts.mkListOf types.str [ ] ''
            Specifies sub paths under which the mypy configuration file may be found.
            For each directory searched for the mypy config file, this also searches the sub paths
            specified here.
          '';

          report_progress = defaultNullOpts.mkBool false ''
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
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin
            (pyls-isort).
          '';
        };

        black = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin
            (python-lsp-black).
          '';

          cache_config = defaultNullOpts.mkBool false ''
            Whether to enable black configuration caching.
          '';

          line_length = defaultNullOpts.mkInt 88 ''
            An integer that maps to black's max-line-length setting.
            Defaults to 88 (same as black's default).
            This can also be set through black's configuration files, which should be preferred for
            multi-user projects.
          '';

          preview = defaultNullOpts.mkBool false ''
            Enable or disable black's --preview setting.
          '';
        };

        memestra = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin
            (pyls-memestra).
          '';
        };

        rope = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin
            (pylsp-rope).
          '';
        };

        ruff = {
          enabled = defaultNullOpts.mkBool false ''
            Enable or disable the plugin.
            Setting this explicitly to `true` will install the dependency for this plugin
            (python-lsp-ruff).
          '';

          config = mkNullOrOption types.str "Path to optional pyproject.toml file.";

          exclude = defaultNullOpts.mkListOf types.str [ ] ''
            Exclude files from being checked by ruff.
          '';

          executable = mkNullOrOption types.str ''
            Path to the ruff executable. Assumed to be in PATH by default.
          '';

          ignore = defaultNullOpts.mkListOf types.str [ ] ''
            Error codes to ignore.
          '';

          extendIgnore = defaultNullOpts.mkListOf types.str [ ] ''
            Same as ignore, but append to existing ignores.
          '';

          lineLength = mkNullOrOption types.int "Set the line-length for length checks.";

          perFileIgnores = mkNullOrOption (with types; attrsOf (listOf str)) ''
            File-specific error codes to be ignored.
          '';

          select = defaultNullOpts.mkListOf types.str [ ] ''
            List of error codes to enable.
          '';

          extendSelect = defaultNullOpts.mkListOf types.str [ ] ''
            Same as select, but append to existing error codes.
          '';

          format = defaultNullOpts.mkListOf types.str [ ] ''
            List of error codes to fix during formatting.
            The default is ["I"], any additional codes are appended to this list.
          '';
        };

        ### END OF THIRD-PARTY PLUGINS
      };

      rope = {
        extensionModules = mkNullOrOption types.str ''
          Builtin and c-extension modules that are allowed to be imported and inspected by rope.
        '';

        ropeFolder = mkNullOrOption (types.listOf types.str) ''
          The name of the folder in which rope stores project configurations and data.
          Pass null for not using such a folder at all.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # WARNING: tricky stuff below:
    # We need to fix the `python-lsp-server` derivation by adding all of the (user enabled)
    # plugins to its `propagatedBuildInputs`.
    # See https://github.com/NixOS/nixpkgs/issues/229337
    plugins.lsp.servers.pylsp.package =
      let
        isEnabled = x: (x.enabled != null && x.enabled);
        inherit (cfg.settings) plugins;

        nativePlugins =
          (map
            (
              pluginName:
              (lib.optionals (isEnabled plugins.${pluginName}) cfg.package.optional-dependencies.${pluginName})
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
            ]
          )
          ++ (lib.optionals (
            (isEnabled plugins.rope_autoimport) || (isEnabled plugins.rope_completion)
          ) cfg.package.optional-dependencies.rope);

        # All of those plugins have `python-lsp-server` as a dependency.
        # We need to get rid of it to add them to the `python-lsp-server` derivation itself.
        thirdPartyPlugins = lib.lists.flatten (
          lib.mapAttrsToList
            (
              pluginName: nixPackage:
              (lib.optional (isEnabled plugins.${pluginName}) (
                nixPackage.overridePythonAttrs (old: {
                  # Get rid of the python-lsp-server dependency
                  dependencies = lib.filter (dep: dep.pname != "python-lsp-server") old.dependencies;

                  # Skip testing because those naked dependencies will complain about missing pylsp
                  doCheck = false;
                })
              ))
            )
            (
              with cfg.pythonPackage.pkgs;
              {
                pylsp_mypy = pylsp-mypy.overridePythonAttrs (old: {
                  postPatch = old.postPatch or "" + ''
                    substituteInPlace setup.cfg \
                      --replace-fail "python-lsp-server >=1.7.0" ""
                  '';
                });
                isort = pyls-isort.overridePythonAttrs (old: {
                  postPatch = old.postPatch or "" + ''
                    substituteInPlace setup.py \
                      --replace-fail 'install_requires=["python-lsp-server", "isort"],' 'install_requires=["isort"],'
                  '';
                });
                black = python-lsp-black.overridePythonAttrs (old: {
                  postPatch = old.postPatch or "" + ''
                    substituteInPlace setup.cfg \
                      --replace-fail "python-lsp-server>=1.4.0" ""
                  '';
                });
                memestra = pyls-memestra.overridePythonAttrs (old: {
                  postPatch = old.postPatch or "" + ''
                    sed -i '/python-lsp-server/d' requirements.txt
                  '';
                });
                rope = pylsp-rope.overridePythonAttrs (old: {
                  postPatch = old.postPatch or "" + ''
                    sed -i '/python-lsp-server/d' setup.cfg
                  '';
                });
                ruff = python-lsp-ruff.overridePythonAttrs (old: {
                  postPatch = old.postPatch or "" + ''
                    sed -i '/python-lsp-server/d' pyproject.toml
                  '';

                  build-system = [ setuptools ] ++ (old.build-system or [ ]);
                });
              }
            )
        );

        # Final list of pylsp plugins to install
        pylspPlugins = nativePlugins ++ thirdPartyPlugins;
      in
      lib.mkDefault (
        # This is the final default package for pylsp
        cfg.pythonPackage.pkgs.python-lsp-server.overridePythonAttrs (old: {
          propagatedBuildInputs = pylspPlugins ++ old.dependencies;
          disabledTests = (old.disabledTests or [ ]) ++ [
            # Those tests fail when third-party plugins are loaded
            "test_notebook_document__did_open"
            "test_notebook_document__did_change"

            # test/plugins/test_autoimport.py:322: AssertionError
            # E       assert False
            # E        +  where False = any(<generator object test_autoimport_code_actions_and_completions_for_notebook_document.<locals>.<genexpr> at 0x7fff54a2eb20>)
            "test_autoimport_code_actions_and_completions_for_notebook_document"
          ];
        })
      );
  };
}
