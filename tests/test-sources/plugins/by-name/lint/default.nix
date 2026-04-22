{ lib, pkgs, ... }:
{
  empty = {
    plugins.lint.enable = true;
  };

  all-linters =
    let
      inherit (import ../../../../../plugins/by-name/lint/auto-install.nix { inherit lib pkgs; })
        getPackageOrStateByName
        ;
      resolvedLinters = map (name: {
        inherit name;
        result = getPackageOrStateByName {
          definedLinters = [ ];
          overrides = { };
        } name;
      }) (lib.importJSON ../../../../../generated/lint-linters.json);
      installableLinters = map (x: x.name) (
        builtins.filter (
          x:
          x.result ? right
          && lib.meta.availableOn pkgs.stdenv.hostPlatform x.result.right
          && !(x.result.right.meta.broken or false)
        ) resolvedLinters
      );
      badPackageLinters = builtins.filter (
        x:
        x.result ? right
        && (
          !lib.meta.availableOn pkgs.stdenv.hostPlatform x.result.right
          || (x.result.right.meta.broken or false)
        )
      ) resolvedLinters;
    in
    {
      plugins.lint = {
        enable = true;
        autoInstall = {
          enable = true;
          enableWarnings = false;
        };
        lintersByFt."*" = installableLinters;
      };

      test = {
        buildNixvim = false;
        warnings = expect: [ (expect "count" 0) ];
      };

      assertions = [
        {
          assertion = badPackageLinters == [ ];
          message =
            "The following documented nvim-lint linters resolve to broken or unavailable packages and need an explicit state in plugins/by-name/lint/packages.nix: "
            + lib.concatMapStringsSep ", " (
              x: "${x.name} -> ${x.result.right.pname or x.result.right.name or "drv"}"
            ) badPackageLinters;
        }
      ];
    };

  auto-install =
    { config, ... }:
    {
      plugins.lint = {
        enable = true;
        autoInstall.enable = true;
        lintersByFt = {
          json = [ "jsonlint" ];
          terraform = [
            "tflint"
            "tofu"
          ];
        };
      };

      test = {
        buildNixvim = false;
        warnings = expect: [
          (expect "count" 1)
          (expect "any" "jsonlint")
          (expect "any" "not packaged in nixpkgs")
        ];
      };

      assertions = [
        {
          assertion = lib.elem pkgs.tflint config.extraPackages;
          message = "Expected `tflint` to be in `extraPackages`.";
        }
        {
          assertion = lib.elem pkgs.opentofu config.extraPackages;
          message = "Expected `opentofu` to be in `extraPackages` for the `tofu` linter.";
        }
      ];
    };

  linux-only-auto-install =
    { config, ... }:
    let
      inherit (pkgs.stdenv) isLinux;
    in
    {
      plugins.lint = {
        enable = true;
        autoInstall.enable = true;
        lintersByFt.systemd = [ "systemd-analyze" ];
      };

      test = {
        buildNixvim = false;
        warnings =
          expect:
          if isLinux then
            [ (expect "count" 0) ]
          else
            [
              (expect "count" 1)
              (expect "any" "only available on Linux")
            ];
      };

      assertions = [
        {
          assertion = isLinux == lib.elem pkgs.systemd config.extraPackages;
          message =
            if isLinux then
              "Expected `systemd` to be in `extraPackages` on Linux."
            else
              "Expected `systemd` not to be in `extraPackages` on non-Linux systems.";
        }
      ];
    };

  auto-install-renamed-package =
    { config, ... }:
    {
      plugins.lint = {
        enable = true;
        autoInstall.enable = true;
        lintersByFt.fennel = [ "fennel" ];
      };

      test = {
        buildNixvim = false;
        warnings = expect: [ (expect "count" 0) ];
      };

      assertions = [
        {
          assertion = lib.elem pkgs.luaPackages.fennel config.extraPackages;
          message = "Expected `luaPackages.fennel` to be in `extraPackages` for the `fennel` linter.";
        }
      ];
    };

  auto-install-broken-alias =
    { config, ... }:
    {
      plugins.lint = {
        enable = true;
        autoInstall.enable = true;
        lintersByFt.php = [ "phpstan" ];
      };

      test = {
        buildNixvim = false;
        warnings = expect: [ (expect "count" 0) ];
      };

      assertions = [
        {
          assertion = lib.elem pkgs.phpstan config.extraPackages;
          message = "Expected `phpstan` to be in `extraPackages` for the `phpstan` linter.";
        }
      ];
    };

  auto-install-null-override =
    { config, ... }:
    {
      plugins.lint = {
        enable = true;
        autoInstall = {
          enable = true;
          overrides.jsonlint = null;
        };
        lintersByFt.json = [ "jsonlint" ];
      };

      test = {
        buildNixvim = false;
        warnings = expect: [ (expect "count" 0) ];
      };

      assertions = [
        {
          assertion = config.extraPackages == [ ];
          message = "Expected `null` overrides to skip auto-installing the linter package.";
        }
      ];
    };

  example = {
    plugins.lint = {
      enable = true;

      lintersByFt = {
        text = [ "vale" ];
        json = [ "jsonlint" ];
        markdown = [ "vale" ];
        rst = [ "vale" ];
        ruby = [ "ruby" ];
        janet = [ "janet" ];
        inko = [ "inko" ];
        clojure = [ "clj-kondo" ];
        dockerfile = [ "hadolint" ];
        terraform = [ "tflint" ];
      };
      linters = {
        phpcs.args = [
          "-q"
          "--report=json"
          "-"
        ];
      };
      customLinters = {
        foo = {
          cmd = "foo_cmd";
          stdin = true;
          append_fname = false;
          args = [ ];
          stream = "stderr";
          ignore_exitcode = false;
          env = {
            FOO = "bar";
          };
          parser = ''
            require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts)
          '';
        };
        foo2 = {
          cmd = "foo2_cmd";
          parser = ''
            require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts)
          '';
        };
        bar.__raw = ''
          function()
            return {
              cmd = "foo_cmd",
              stdin = true,
              append_fname = false,
              args = {},
              stream = "stderr",
              ignore_exitcode = false,
              env = {
                ["FOO"] = "bar",
              },
              parser = require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts),
            }
          end
        '';
      };
    };
  };
}
