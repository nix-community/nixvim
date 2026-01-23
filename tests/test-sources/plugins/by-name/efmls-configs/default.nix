{
  empty = {
    plugins.efmls-configs.enable = true;
  };

  all =
    { options, ... }:
    let
      inherit (options.plugins.efmls-configs) languages;

      # toolOptions is an attrsets of the form:
      # { <lang> = { linter = tools; formatter = tools; }; }
      # Where tools is the option type representing the valid tools for this language
      toolOptions = removeAttrs (languages.type.getSubOptions languages.loc) [
        "_freeformOptions"
        "_module"

        # Rename aliases added 2025-06-25 in https://github.com/nix-community/nixvim/pull/3503
        "warnings"
        "HTML"
        "JSON"
      ];

      brokenTools = [
        # TODO: 2026-01-23: dmd build failure with gcc 15 (nullptr identifier)
        "dfmt"
        "dmd"

        # 2025-12-24: phpPackages.php-codesniffer is broken
        # https://github.com/NixOS/nixpkgs/pull/459254#issuecomment-3689578764
        "phpcbf"
        "phpcs"
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
        "jsonlint"
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
        "typstfmt"
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
        languages = builtins.mapAttrs (_: builtins.mapAttrs (_: toolsFromOptions)) toolOptions;
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

      languages = {
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
    plugins.efmls-configs.enable = true;
    dependencies.efm-langserver.enable = false;
  };
}
