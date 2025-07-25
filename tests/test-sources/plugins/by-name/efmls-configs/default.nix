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
      inherit (pkgs.stdenv) hostPlatform;
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
        #TODO Added 2025-04-01
        # php-cs-fixer is marked as broken
        "php_cs_fixer"
        # TODO: Added 2025-04-19 broken dependency
        "phan"
        "php"
        "phpcbf"
        "phpcs"
        "phpstan"
        "psalm"
      ]
      ++ lib.optionals (hostPlatform.isLinux && hostPlatform.isAarch64) [
        # TODO: 2025-04-20 build failure (swift-corelibs-xctest)
        "swiftformat"
      ]
      ++ lib.optionals hostPlatform.isDarwin [
        # As of 2024-01-04, texliveMedium is broken on darwin
        # TODO: re-enable those tests when fixed
        "chktex"
        "latexindent"

        # TODO 2025-04-20 build failure
        "ansible_lint"
      ]
      ++ lib.optionals (hostPlatform.isDarwin && hostPlatform.isAarch64) [
        # As of 2025-03-18, several python311Packages.* dependencies of bashate fail on aarch64-darwin
        # TODO: re-enable this test when fixed
        "bashate"
      ]
      ++ lib.optionals (hostPlatform.isDarwin && hostPlatform.isx86_64) [
        # As of 2024-07-31, dmd is broken on x86_64-darwin
        # https://github.com/NixOS/nixpkgs/pull/331373
        # TODO: re-enable this test when fixed
        "dmd"
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
