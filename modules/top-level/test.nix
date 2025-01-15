{
  pkgs,
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.test;

  # Expectation submodule used for checking warnings and/or assertions
  expectationType = lib.types.submodule (
    { config, ... }:
    let
      # NOTE: ensure `config.expect != null` before evaluating this!
      namedPredicate = cfg.namedExpectationPredicates.${config.expect};
    in
    {
      options = {
        predicate = lib.mkOption {
          type = with lib.types; functionTo bool;
          description = ''
            A predicate of that determines whether this expectation is met.

            Type
            ```
            [String] -> Boolean
            ```

            Parameters
            1. values - all warnings or matched assertions
          '';
        };
        expect = lib.mkOption {
          type = with lib.types; nullOr (enum (builtins.attrNames cfg.namedExpectationPredicates));
          description = ''
            If non-null, will be used together with `value` to define `predicate`.
          '';
          default = null;
        };
        value = lib.mkOption {
          type =
            if config.expect == null then
              lib.types.unspecified
              // {
                description = ''
                  Depends on `expect`:
                  ${lib.concatStringsSep "\n" (
                    lib.mapAttrsToList (
                      name: spec: "- ${builtins.toJSON name}: ${spec.valueType.description}"
                    ) cfg.namedExpectationPredicates
                  )}
                '';
              }
            else
              namedPredicate.valueType;
          description = ''
            If defined, will be used together with `expect` to define `predicate`.
          '';
        };
        message = lib.mkOption {
          type = with lib.types; either str (functionTo str);
          description = ''
            The assertion message.

            If the value is a function, it is called with the same list of warning/assertion messages that is applied to `predicate`.
          '';
          defaultText = lib.literalMD ''
            If `assertion` is non-null, a default is computed. Otherwise, there is no default.
          '';
        };
      };
      config = lib.mkIf (config.expect != null) {
        predicate = lib.mkOptionDefault (namedPredicate.predicate config.value);
        message = lib.mkOptionDefault (namedPredicate.message config.value);
      };
    }
  );
in
{
  options.test = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "nixvim-check";
      description = "The test derivation's name.";
    };

    buildNixvim = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to build the nixvim config in the test.";
      default = true;
    };

    runNvim = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to run `nvim` in the test.";
      defaultText = lib.literalExpression "config.test.buildNixvim";
      default = cfg.buildNixvim;
    };

    checkWarnings = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to check `config.warnings` in the test. (deprecated)";
      apply = x: lib.warnIfNot x "`test.checkWarnings = false` is replaced with `test.warnings = [ ]`." x;
      default = true;
      visible = false;
    };

    checkAssertions = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to check `config.assertions` in the test. (deprecated)";
      apply =
        x: lib.warnIfNot x "`test.checkAssertions = false` is replaced with `test.assertions = [ ]`." x;
      default = true;
      visible = false;
    };

    warnings = lib.mkOption {
      type = lib.types.listOf expectationType;
      description = "A list of expectations for `warnings`.";
      defaultText = lib.literalMD "Expect `count == 0`";
      default = [
        {
          expect = "count";
          value = 0;
        }
      ];
    };

    assertions = lib.mkOption {
      type = lib.types.listOf expectationType;
      description = "A list of expectations for `assertions`.";
      defaultText = lib.literalMD "Expect `count == 0`";
      default = [
        {
          expect = "count";
          value = 0;
        }
      ];
    };

    namedExpectationPredicates = lib.mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            predicate = lib.mkOption {
              type = functionTo (functionTo bool);
              description = ''
                Predicate matching `(value) -> [(message)] -> Boolean`.
              '';
            };
            message = lib.mkOption {
              type = functionTo (either str (functionTo str));
              description = ''
                Expectation message supplier, matching `(value) -> String` or `(value) -> [(message)] -> String`.
              '';
            };
            valueType = lib.mkOption {
              type = lib.types.optionType;
              description = ''
                The type to use for `value` when this expectation is used.
              '';
            };
          };
        });
      description = ''
        A list of named expectation predicates, for use with `test.warnings.*.expect` and `test.assertions.*.expect`.
      '';
      internal = true;
    };
  };

  options.build = {
    test = lib.mkOption {
      type = lib.types.package;
      description = ''
        A derivation that tests the config by running neovim.
      '';
      readOnly = true;
    };
  };

  config =
    let
      input = {
        inherit (config) warnings;
        assertions = builtins.concatMap (x: lib.optional (!x.assertion) x.message) config.assertions;
      };

      expectationMessages =
        name:
        lib.pipe cfg.${name} [
          (builtins.filter (x: !x.predicate input.${name}))
          (builtins.map (x: x.message))
          (builtins.map (msg: if lib.isFunction msg then msg input.${name} else msg))
          (
            x:
            if x == [ ] then
              null
            else
              ''
                Failed ${toString (builtins.length x)} expectation${lib.optionalString (builtins.length x > 1) "s"}:
                ${lib.concatMapStringsSep "\n" (line: "- ${line}") x}
                For ${name}:
                ${lib.concatMapStringsSep "\n" (line: "- ${line}") input.${name}}
              ''
          )
        ];

      failedExpectations = lib.genAttrs [ "warnings" "assertions" ] expectationMessages;
    in
    {
      test = {
        # If checkWarnings or checkAssertions are disabled, ensure the default expectations are overridden
        assertions = lib.mkIf (!cfg.checkAssertions) [ ];
        warnings = lib.mkIf (!cfg.checkWarnings) [ ];

        # Expectation predicates available via the `expect` enum-option
        namedExpectationPredicates = {
          count = {
            predicate = v: l: builtins.length l == v;
            message = v: l: "Expected length to be ${toString v} but found ${toString (builtins.length l)}.";
            valueType = lib.types.ints.unsigned;
          };
          any = {
            predicate = v: builtins.any (lib.hasInfix v);
            message = v: "Expected ${builtins.toJSON v} infix to be present.";
            valueType = lib.types.str;
          };
          anyExact = {
            predicate = builtins.elem;
            message = v: "Expected ${builtins.toJSON v} to be present.";
            valueType = lib.types.str;
          };
        };
      };

      build.test =
        assert lib.assertMsg (cfg.runNvim -> cfg.buildNixvim) "`test.runNvim` requires `test.buildNixvim`.";
        pkgs.runCommandLocal cfg.name
          {
            nativeBuildInputs = lib.optionals cfg.buildNixvim [
              config.build.packageUnchecked
            ];

            inherit (failedExpectations) warnings assertions;

            # Allow inspecting the test's module a little from the repl
            # e.g.
            # :lf .
            # :p checks.x86_64-linux.test-1.passthru.entries.modules-autocmd.passthru.entries.example.passthru.config.extraConfigLua
            #
            # Yes, three levels of passthru is cursed.
            passthru = {
              inherit config options;
            };
          }
          (
            # First check warnings/assertions, then run nvim
            ''
              if [ -n "$warnings" ]; then
                echo -n "$warnings"
                exit 1
              fi
              if [ -n "$assertions" ]; then
                echo -n "$assertions"
                exit 1
              fi
            ''
            # We need to set HOME because neovim will try to create some files
            #
            # Because neovim does not return an exitcode when quitting we need to check if there are
            # errors on stderr
            + lib.optionalString cfg.runNvim ''
              mkdir -p .cache/nvim

              output=$(HOME=$(realpath .) nvim -mn --headless "+q" 2>&1 >/dev/null)
              if [[ -n $output ]]; then
                echo "ERROR: $output"
                exit 1
              fi
            ''
            + ''
              touch $out
            ''
          );
    };
}
