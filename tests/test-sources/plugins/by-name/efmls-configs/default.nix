{
  empty = {
    plugins.efmls-configs.enable = true;
  };

  all =
    { options, ... }:
    let
      inherit (options.plugins.efmls-configs) setup;

      # toolOptions is an attrsets of the form:
      # { <lang> = { linter = tools; formatter = tools; }; }
      # Where tools is the option type representing the valid tools for this language
      toolOptions = builtins.removeAttrs (setup.type.getSubOptions setup.loc) [
        "_freeformOptions"
        "_module"

        # Rename aliases added 2025-06-25 in https://github.com/nix-community/nixvim/pull/3503
        "warnings"
        "HTML"
        "JSON"
      ];

      brokenTools = [
        # 2025-10-12 build failure (luaformatter depends on broken antlr-runtime-cpp)
        "lua_format"

        # TODO Added 2025-04-01
        # php-cs-fixer is marked as broken
        "php_cs_fixer"

        # TODO: Added 2025-04-19 broken dependency
        "phan"
        "php"
        "phpcbf"
        "phpcs"
        "phpstan"
        "psalm"
      ];

      # TODO: respect unpackaged from generated
      unpackaged = [
        "blade_formatter"
        "cljstyle"
        "cspell"
        "dartanalyzer"
        "debride"
        "deno_fmt"
        "fecs"
        "fixjson"
        "forge_fmt"
        "gersemi"
        "gleam_format"
        "js_standard"
        "kdlfmt"
        "markuplint"
        "mix"
        "pint"
        "prettier_eslint"
        "prettier_standard"
        "redpen"
        "reek"
        "rome"
        "ruff_sort"
        "slim_lint"
        "solhint"
        "sorbet"
        "swiftformat"
        "swiftlint"
        "xo"
      ];

      # Fetch the valid enum members from the tool options
      toolsFromOptions =
        opt:
        let
          # tool options are a `either toolType (listOf toolType)`
          # Look into `nestedTypes.left` to get a `toolType` option.
          toolType = opt.type.nestedTypes.left;
          # toolType is a `either (enum possible) rawLua
          # Look into `nestedTypes.left` for the enum
          possible = toolType.nestedTypes.elemType;
          # possible is an enum, look into functor.payload for the variants
          toolList = possible.functor.payload.values;
        in
        builtins.filter (t: !builtins.elem t (brokenTools ++ unpackaged)) toolList;
    in
    {
      plugins.efmls-configs = {
        enable = true;

        # Replace the { <lang> = { linter = tools; formatter = tools; } };
        # With { <lang> = {
        #          linter = [<all valid linters for lang>];
        #          formatter = [<all valid formatters for lang>];
        #       };}
        setup = builtins.mapAttrs (_: builtins.mapAttrs (_: toolsFromOptions)) toolOptions;
      };
    };

  example = {
    extraConfigLuaPre = ''
      local efm_fs = require('efmls-configs.fs')
      local djlint_fmt = {
        formatCommand = string.format('%s --reformat ''${INPUT} -', efm_fs.executable('djlint')),
        formatStdin = true,
      }
    '';

    plugins.efmls-configs = {
      enable = true;

      setup = {
        # Setup for all languages
        all = {
          linter = "vale";
        };

        # Only accepts known tools, or raw strings
        html = {
          formatter = [
            "prettier"
            { __raw = "djlint_fmt"; }
          ];
        };

        # Unknown filetype, accepts anything
        htmldjango = {
          formatter = [ { __raw = "djlint_fmt"; } ];
          linter = "djlint";
        };
      };
    };
  };

  no-packages = {
    plugins.efmls-configs = {
      enable = true;
      efmLangServerPackage = null;
    };
  };
}
