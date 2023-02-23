{
  lib,
  config,
  ...
}:
with lib; let
  helpers = import ../../helpers.nix {inherit lib;};
  cfg = config.plugins.lsp.servers.pylsp;
in {
  # All settings are documented here:
  # https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md

  options.plugins.lsp.servers.pylsp.settings = {
    configurationSources = mkOption {
      type = lib.types.nullOr (types.enum ["pycodestyle" "flake8"]);
      description = "List of configuration sources to use.";
      default = null;
      apply = (
        value:
          if (value != null)
          then [value]
          else null
      );
    };

    plugins = {
      autopep8 = {
        enabled = mkOption {
          type = types.bool;
          description = ''
            Enable or disable the plugin (disabling required to use `yapf`).
          '';
          default = true;
        };
      };

      flake8 = {
        config = helpers.mkNullOrOption types.str ''
          Path to the config file that will be the authoritative config source.
        '';

        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = false;
        };

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
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };

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
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };

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
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };
      };

      jedi_references = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };
      };

      jedi_signature_help = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };
      };

      jedi_symbols = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };

        all_scopes = helpers.defaultNullOpts.mkBool true ''
          If true lists the names of all scopes instead of only the module namespace.
        '';

        include_import_symbols = helpers.defaultNullOpts.mkBool true ''
          If true includes symbols imported from other libraries.
        '';
      };

      mccabe = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };

        threshold = helpers.defaultNullOpts.mkInt 15 ''
          The minimum threshold that triggers warnings about cyclomatic complexity.
        '';
      };

      preload = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };

        modules = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
          List of modules to import on startup.
        '';
      };

      pycodestyle = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };

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
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = false;
        };

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
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };
      };

      pylint = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = false;
        };

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
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable autoimport.";
          default = false;
        };

        memory = helpers.defaultNullOpts.mkBool false ''
          Make the autoimport database memory only.
          Drastically increases startup time.
        '';
      };

      rope_completion = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = false;
        };

        eager = helpers.defaultNullOpts.mkBool false ''
          Resolve documentation and detail eagerly.
        '';
      };

      yapf = {
        enabled = mkOption {
          type = types.bool;
          description = "Enable or disable the plugin.";
          default = true;
        };
      };
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
      extraPackages = with cfg.settings;
        lists.flatten (map
          (
            pluginName: (
              optionals plugins.${pluginName}.enabled
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
          (plugins.rope_autoimport.enabled || plugins.rope_completion.enabled)
          cfg.package.optional-dependencies.rope
        );
    };
}
