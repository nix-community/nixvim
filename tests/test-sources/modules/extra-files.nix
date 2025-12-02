let
  checkExtraFiles =
    pkgs:
    {
      name,
      extraFilesDir,
      expectedTargets,
    }:
    pkgs.runCommand name
      {
        inherit extraFilesDir expectedTargets;
        __structuredAttrs = true;
      }
      ''
        set -euo pipefail

        for target in "''${!expectedTargets[@]}"; do
          file="$extraFilesDir/$target"
          expected="''${expectedTargets["$target"]}"

          if [ ! -e "$file" ]; then
            echo "Missing target: $file"
            exit 1
          fi

          if [ -n "$expected" ] && ! grep -qF "$expected" "$file"; then
            echo "Content mismatch: $file"
            exit 1
          fi
        done

        touch $out
      '';
in
{
  # Example
  query = {
    extraFiles."queries/lua/injections.scm".text = ''
      ;; extends
    '';
  };

  empty = {
    extraFiles = { };
  };

  happy-path =
    { config, pkgs, ... }:
    {
      extraFiles = {
        # Basic tests
        "testing/test-case.nix".source = ./extra-files.nix;
        "testing/123.txt".text = ''
          One
          Two
          Three
        '';

        # Multiple files in the same directory
        "foo/a".text = "A";
        "foo/b".text = "B";
        "foo/c".text = "C";

        # Nested deep path
        "a/b/c/d/e.txt".text = "deep";

        # Directory source
        "beta/dir".source = pkgs.emptyDirectory;

        # Mixed: source file + hello source
        "hello/source".source = pkgs.hello;
      };
      test.runNvim = false;
      test.extraInputs = [
        (checkExtraFiles pkgs {
          name = "check-happy-path";
          extraFilesDir = config.build.extraFiles;
          expectedTargets = {
            "testing/test-case.nix" = null;
            "testing/123.txt" = "One\nTwo\nThree";
            "foo/a" = "A";
            "foo/b" = "B";
            "foo/c" = "C";
            "a/b/c/d/e.txt" = "deep";
            "beta/dir" = null;
            "hello/source" = null;
          };
        })
      ];
    };

  # Special content edge cases
  special-files =
    { config, pkgs, ... }:
    {
      extraFiles = {
        "empty.txt".text = "";
        "whitespace.txt".text = "   \n\t  ";
        "файл.txt".text = "unicode";
        "目录/文件.txt".text = "chinese";
      };
      test.runNvim = false;
      test.extraInputs = [
        (checkExtraFiles pkgs {
          name = "check-special-files";
          extraFilesDir = config.build.extraFiles;
          expectedTargets = {
            "empty.txt" = "";
            "whitespace.txt" = "   ";
            "файл.txt" = "unicode";
            "目录/文件.txt" = "chinese";
          };
        })
      ];
    };

  identical-duplicates =
    { config, pkgs, ... }:
    {
      extraFiles.a = {
        target = "hello.txt";
        text = "hello";
      };
      extraFiles.b = {
        target = "hello.txt";
        text = "hello";
      };
      extraFiles.c = {
        target = "empty.txt";
        source = pkgs.emptyFile;
      };
      extraFiles.d = {
        target = "empty.txt";
        source = pkgs.emptyFile;
      };
      extraFiles.e = {
        target = "emptyDir";
        source = pkgs.emptyDirectory;
      };
      extraFiles.f = {
        target = "emptyDir";
        source = pkgs.emptyDirectory;
      };
      test.buildNixvim = false;
      test.extraInputs = [
        (checkExtraFiles pkgs {
          name = "check-identical-duplicates";
          extraFilesDir = config.build.extraFiles;
          expectedTargets = {
            "hello.txt" = "hello";
            "empty.txt" = null;
            "emptyDir" = null;
          };
        })
      ];
    };

  duplicate-mismatch =
    { config, pkgs, ... }:
    {
      extraFiles.a = {
        target = "conflict.txt";
        text = "abc";
      };
      extraFiles.b = {
        target = "conflict.txt";
        text = "xyz";
      };
      test.buildNixvim = false;
      test.extraInputs = [
        (pkgs.runCommand "expect-duplicate-failure"
          { failure = pkgs.testers.testBuildFailure config.build.extraFiles; }
          ''
            exit_code=$(cat "$failure/testBuildFailure.exit")
            (( exit_code == 1 )) || {
              echo "Expected exit code 1"
              exit 1
            }
            grep -q "target 'conflict.txt' defined multiple times with different sources:" "$failure/testBuildFailure.log"
            drv_count=$(grep -c '/nix/store/.*-nvim-.' "$failure/testBuildFailure.log")
            (( drv_count == 2 )) || {
              echo "Expected 2 store path matches, got $drv_count"
              exit 1
            }
            touch $out
          ''
        )
      ];
    };

  prefix-conflicts = {
    extraFiles = {
      # 2-level conflict
      "foo".text = "root";
      "foo/bar.txt".text = "child";

      # 3-level conflict
      "baz".text = "parent";
      "baz/qux".text = "child";
      "baz/qux/quux.txt".text = "grandchild";

      # 5-level conflict
      "a".text = "1";
      "a/b".text = "2";
      "a/b/c".text = "3";
      "a/b/c/d".text = "4";
      "a/b/c/d/e.txt".text = "5";

      # Non-conflicting paths
      "abc".text = "solo";
      "def/ghi.txt".text = "leaf";
      "solo".text = "single";
      "x/y.txt".text = "leaf";
    };

    test.assertions = expect: [
      (expect "count" 1)
      (expect "anyExact" ''
        Nixvim (extraFiles): Conflicting target prefixes:
          - a ↔ a/b
          - a/b ↔ a/b/c
          - a/b/c ↔ a/b/c/d
          - a/b/c/d ↔ a/b/c/d/e.txt
          - baz ↔ baz/qux
          - baz/qux ↔ baz/qux/quux.txt
          - foo ↔ foo/bar.txt'')
    ];

    test.buildNixvim = false;
  };
}
