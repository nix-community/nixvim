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
            grep -q "target 'conflict.txt' defined twice with different sources" "$failure/testBuildFailure.log"
            touch $out
          ''
        )
      ];
    };

  file-vs-dir-conflict =
    { config, pkgs, ... }:
    {
      extraFiles."conflict".text = "file";
      extraFiles."conflict/file.txt".text = "nested";
      test.buildNixvim = false;
      test.extraInputs = [
        (pkgs.runCommand "expect-conflict-failure"
          { failure = pkgs.testers.testBuildFailure config.build.extraFiles; }
          ''
            exit_code=$(cat "$failure/testBuildFailure.exit")
            (( exit_code == 1 )) || {
              echo "Expected exit code 1"
              exit 1
            }
            grep -q "is a target, but another target conflicts:" "$failure/testBuildFailure.log"
            touch $out
          ''
        )
      ];
    };

  dir-vs-file-conflict =
    { config, pkgs, ... }:
    {
      extraFiles."conflictDir".source = pkgs.emptyDirectory;
      extraFiles."conflictDir/file.txt".text = "nested";
      test.buildNixvim = false;
      test.extraInputs = [
        (pkgs.runCommand "expect-dir-conflict-failure"
          { failure = pkgs.testers.testBuildFailure config.build.extraFiles; }
          ''
            exit_code=$(cat "$failure/testBuildFailure.exit")
            (( exit_code == 1 )) || {
              echo "Expected exit code 1"
              exit 1
            }
            grep -q "is a target, but another target conflicts:" "$failure/testBuildFailure.log"
            touch $out
          ''
        )
      ];
    };
}
