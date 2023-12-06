{
  efmls-options,
  pkgs,
  ...
}: {
  empty = {
    plugins.efmls-configs.enable = true;
  };

  all = {
    plugins.efmls-configs = let
      options = efmls-options.options.plugins.efmls-configs;
      # toolOptions is an attrsets of the form:
      # { <lang> = { linter = tools; formatter = tools; }; }
      # Where tools is the option type representing the valid tools for this language
      toolOptions = (builtins.head options.setup.type.getSubModules).options;

      brokenTools = [
        #Broken as of 16 of November 2023
        "phpstan"
      ];

      unpackaged =
        [
          "blade_formatter"
          "cspell"
          "cljstyle"
          "dartanalyzer"
          "debride"
          "fecs"
          "fixjson"
          "forge_fmt"
          "gersemi"
          "js_standard"
          "pint"
          "prettier_eslint"
          "prettier_standard"
          "redpen"
          "reek"
          "rome"
          "slim_lint"
          "solhint"
          "sorbet"
          "xo"
        ]
        ++ (
          pkgs.lib.optionals
          pkgs.stdenv.isDarwin
          ["clazy"]
        )
        ++ (
          pkgs.lib.optionals
          pkgs.stdenv.isAarch64
          [
            "dmd"
            "smlfmt"
          ]
        );

      # Fetch the valid enum members from the tool options
      toolsFromOptions = opt: let
        # tool options are a `either toolType (listOf toolType)`
        # Look into `nestedTypes.left` to get a `toolType` option.
        toolType = opt.type.nestedTypes.left;
        # toolType is a `either (enum possible) helpers.rawType
        # Look into `nestedTypes.left` for the enum
        possible = toolType.nestedTypes.left;
        # possible is an enum, look into functor.payload for the variants
        toolList = possible.functor.payload;
      in
        builtins.filter (t: !builtins.elem t (brokenTools ++ unpackaged)) toolList;
    in {
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
          formatter = ["prettier" {__raw = "djlint_fmt";}];
        };

        # Unknown filetype, accepts anything
        htmldjango = {
          formatter = [{__raw = "djlint_fmt";}];
          linter = "djlint";
        };
      };
    };
  };
}
