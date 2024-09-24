{ makeNixvimWithModule, pkgs }:
let
  extraFiles = {
    "one".text = "one";
    "two".text = "two";
    "nested/in/dirs/file.txt".text = "nested";
    "this/file/test.nix".source = ./extra-files.nix;
  };
  build = makeNixvimWithModule {
    module = {
      inherit extraFiles;
    };
  };
in
pkgs.runCommand "extra-files-test"
  {
    root = build.config.build.extraFiles;
    files = builtins.attrNames extraFiles;
  }
  ''
    for file in $files; do
      path="$root"/"$file"
      if [[ -f "$path" ]]; then
        echo "File $path exists"
      else
        echo "File $path is missing"
        exit 1
      fi
    done

    touch $out
  ''
