{ efmls-options, pkgs, ... }:
{
  empty = {
    plugins.efmls-configs.enable = true;
  };

  all = {
    plugins.efmls-configs =
      let
        options = efmls-options.options.plugins.efmls-configs;
        # toolOptions is an attrsets of the form:
        # { <lang> = { linter = tools; formatter = tools; }; }
        # Where tools is the option type representing the valid tools for this language
        toolOptions = (builtins.head options.setup.type.getSubModules).options;

        brokenTools =
          [
            #Broken as of 16 of November 2023
            "phpstan"
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            # As of 2024-05-22, python311Packages.k5test (one of ansible-lint's dependenvies) is broken on darwin
            # TODO: re-enable this test when fixed
            "ansible_lint"
            # As of 2024-01-04, cbfmt is broken on darwin
            # TODO: re-enable this test when fixed
            "cbfmt"
            # As of 2024-01-04, texliveMedium is broken on darwin
            # TODO: re-enable those tests when fixed
            "chktex"
            "latexindent"
          ]
          ++ pkgs.lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-darwin") [
            # As of 2024-01-04, dmd is broken on x86_64-darwin
            # TODO: re-enable this test when fixed
            "dmd"
            # As of 2024-01-04, luaformat is broken on x86_64-darwin
            # TODO: re-enable this test when fixed
            "lua_format"
            # As of 2024-03-27, pkgs.graalvm-ce (a dependency of pkgs.clj-kondo) is broken on x86_64-darwin
            # TODO: re-enable this test when fixed
            "clj_kondo"
          ];

        unpackaged =
          [
            "blade_formatter"
            "cspell"
            "cljstyle"
            "dartanalyzer"
            "debride"
            "deno_fmt"
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
            "swiftformat"
            "swiftlint"
            "xo"
          ]
          ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [ "clazy" ])
          ++ (pkgs.lib.optionals pkgs.stdenv.isAarch64 [
            "dmd"
            "smlfmt"
            # As of 2024-03-11, swift-format is broken on aarch64
            # TODO: re-enable this test when fixed
            # "swift_format"
          ]);

        # Fetch the valid enum members from the tool options
        toolsFromOptions =
          opt:
          let
            # tool options are a `either toolType (listOf toolType)`
            # Look into `nestedTypes.left` to get a `toolType` option.
            toolType = opt.type.nestedTypes.left;
            # toolType is a `either (enum possible) helpers.nixvimTypes.rawLua
            # Look into `nestedTypes.left` for the enum
            possible = toolType.nestedTypes.left;
            # possible is an enum, look into functor.payload for the variants
            toolList = possible.functor.payload;
          in
          builtins.filter (t: !builtins.elem t (brokenTools ++ unpackaged)) toolList;
      in
      {
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
}
