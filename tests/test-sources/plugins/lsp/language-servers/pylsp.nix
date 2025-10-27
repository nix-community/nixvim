# FIXME: This test uses a lot of "null" values that get ignored
# this should use raw values instead but cannot be implemented due to raw coercions
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
              config = null;
              enabled = true;
              exclude = [ ];
              executable = "flake8";
              filename = null;
              hangClosing = null;
              ignore = [ ];
              maxComplexity = null;
              maxLineLength = null;
              indentSize = null;
              perFileIgnores = [ ];
              select = null;
            };
            jedi = {
              auto_import_modules = [ "numpy" ];
              extra_paths = [ ];
              environment = null;
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
              modules = [ ];
            };
            pycodestyle = {
              enabled = true;
              exclude = [ ];
              filename = [ ];
              ropeFolder = null;
              ignore = [ ];
              hangClosing = true;
              maxLineLength = 80;
              indentSize = 4;
            };
            pydocstyle = {
              enabled = false;
              convention = null;
              addIgnore = [ ];
              addSelect = [ ];
              ignore = [ ];
              select = null;
              match = "(?!test_).*\\.py";
              matchDir = "[^\\.].*";
            };
            pyflakes = {
              enabled = true;
            };
            pylint = {
              enabled = true;
              args = [ ];
              executable = null;
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
              config_sub_paths = [ ];
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
            extensionModules = null;
            ropeFolder = null;
          };
        };
      };
    };
  };
}
