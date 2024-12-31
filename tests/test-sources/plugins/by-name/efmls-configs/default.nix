{
  empty = {
    plugins.efmls-configs.enable = true;
  };

  all =
    {
      lib,
      options,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (options.plugins.efmls-configs) setup;

      # toolOptions is an attrsets of the form:
      # { <lang> = { linter = tools; formatter = tools; }; }
      # Where tools is the option type representing the valid tools for this language
      toolOptions = builtins.removeAttrs (setup.type.getSubOptions setup.loc) [
        "_freeformOptions"
        "_module"
      ];

      brokenTools =
        [
          # TODO: added 2024-09-13
          # Swift broken everywhere atm
          "swiftformat"
          "swiftlint"
          # TODO: added 2024-10-15
          # re-enable after fixed
          "dmd"
          # TODO: added 2024-12-31
          # ansible-compat is broken
          # Fixed by https://github.com/NixOS/nixpkgs/pull/369664
          "ansible_lint"
          # TODO: added 2024-12-31
          # Fixed by https://github.com/NixOS/nixpkgs/pull/369681
          "clazy"
        ]
        ++ lib.optionals (system == "aarch64-linux") [
          # Broken as of 2024-07-13
          # TODO: re-enable this tests when fixed
          "textlint"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          # As of 2024-01-04, texliveMedium is broken on darwin
          # TODO: re-enable those tests when fixed
          "chktex"
          "latexindent"
          # As of 2024-12-31, cppcheck is failing on darwin
          # Fixed by https://github.com/NixOS/nixpkgs/pull/369673
          # TODO: re-enable this test when fixed
          "cppcheck"
        ]
        ++ lib.optionals (system == "x86_64-darwin") [
          # As of 2024-07-31, dmd is broken on x86_64-darwin
          # https://github.com/NixOS/nixpkgs/pull/331373
          # TODO: re-enable this test when fixed
          "dmd"
          # As of 2024-11-03, graalvm-ce (dependency of clj-kondo) is broken on x86_64-darwin
          "clj_kondo"
        ];

      # TODO: respect unpackaged from generated
      unpackaged =
        [
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
          "xo"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [ "clazy" ]
        ++ lib.optionals pkgs.stdenv.isAarch64 [
          "dmd"
          "smlfmt"
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
