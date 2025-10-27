{
  example = {
    plugins.lsp = {
      enable = true;

      servers.pylsp = {
        enable = true;

        settings = {
          configurationSources = "pycodestyle";

          plugins = {
            autopep8 = {
              enabled = true;
            };
            flake8 = {
              config.__raw = "nil";
              enabled = true;
              exclude.__empty = { };
              executable = "flake8";
              filename.__raw = "nil";
              hangClosing.__raw = "nil";
              ignore.__empty = { };
              maxComplexity.__raw = "nil";
              maxLineLength.__raw = "nil";
              indentSize.__raw = "nil";
              perFileIgnores.__empty = { };
              select.__raw = "nil";
            };
            jedi = {
              auto_import_modules = [ "numpy" ];
              extra_paths.__empty = { };
              environment.__raw = "nil";
            };
            jedi_completion = {
              enabled = true;
              include_params = true;
              include_class_objects = false;
              include_function_objects = false;
              fuzzy = false;
              eager = false;
              resolve_at_most = 25;
              cache_for = [
                "pandas"
                "numpy"
                "tensorflow"
                "matplotlib"
              ];
            };
            jedi_definition = {
              enabled = true;
              follow_imports = true;
              follow_builtin_imports = true;
              follow_builtin_definitions = true;
            };
            jedi_hover = {
              enabled = true;
            };
            jedi_references = {
              enabled = true;
            };
            jedi_signature_help = {
              enabled = true;
            };
            jedi_symbols = {
              enabled = true;
              all_scopes = true;
              include_import_symbols = true;
            };
            mccabe = {
              enabled = true;
              threshold = 15;
            };
            preload = {
              enabled = true;
              modules.__empty = { };
            };
            pycodestyle = {
              enabled = true;
              exclude.__empty = { };
              filename.__empty = { };
              ropeFolder.__raw = "nil";
              ignore.__empty = { };
              hangClosing = true;
              maxLineLength = 80;
              indentSize = 4;
            };
            pydocstyle = {
              enabled = false;
              convention.__raw = "nil";
              addIgnore.__empty = { };
              addSelect.__empty = { };
              ignore.__empty = { };
              select.__raw = "nil";
              match = "(?!test_).*\\.py";
              matchDir = "[^\\.].*";
            };
            pyflakes = {
              enabled = true;
            };
            pylint = {
              enabled = true;
              args.__empty = { };
              executable.__raw = "nil";
            };
            rope_autoimport = {
              enabled = true;
              memory = false;
            };
            rope_completion = {
              enabled = true;
              eager = false;
            };
            yapf = {
              enabled = true;
            };
            # Third party plugins
            pylsp_mypy = {
              enabled = true;
              live_mode = true;
              dmypy = false;
              strict = false;
              overrides = [ true ];
              dmypy_status_file = ".dmypy.json";
              config_sub_paths.__empty = { };
              report_progress = false;
            };
            black = {
              enabled = true;
              cache_config = true;
              line_length = 100;
              preview = true;
            };
            memestra = {
              enabled = true;
            };
            rope = {
              enabled = true;
            };
            ruff = {
              enabled = true;
              config = "/foo/bar/pyproject.toml";
              exclude = [
                "foo"
                "bar"
              ];
              executable = "/foo/bar/ruff";
              ignore = [
                "E42"
                "E720"
              ];
              extendIgnore = [ "E12" ];
              lineLength = 123;
              perFileIgnores = {
                "__init__.py" = [ "E402" ];
                "path/to/file.py" = [ "E402" ];
              };
              select = [
                "E01"
                "E56"
              ];
              extendSelect = [ "E68" ];
              format = [ "E90" ];
            };
          };
          rope = {
            extensionModules.__raw = "nil";
            ropeFolder.__raw = "nil";
          };
        };
      };
    };
  };
}
