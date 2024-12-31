{
  lib,
  nixvimConfiguration,
  linkFarmFromDrvs,
  runCommandLocal,
}:
let
  by-name = ../plugins/by-name;
  options = lib.collect lib.isOption nixvimConfiguration.options;

  # Option namespaces that we allow by-name plugins to declare
  knownPluginNamespaces = [
    "colorschemes"
    "plugins"
  ];

  # Group by-name children by filetype; "regular", "directory", "symlink" and "unknown".
  children =
    let
      apply =
        prev: name: type:
        prev // { ${type} = prev.${type} ++ [ name ]; };

      nil = {
        regular = [ ];
        directory = [ ];
        symlink = [ ];
        unknown = [ ];
      };
    in
    lib.foldlAttrs apply nil (builtins.readDir by-name);

  # Find plugins by looking for `*.*.enable` options that are declared in `plugins/by-name`
  by-name-enable-opts =
    let
      regex = ''/nix/store/[^/]+/plugins/by-name/(.*)'';
      optionalPair =
        opt: file:
        let
          result = builtins.match regex file;
        in
        lib.optional (result != null) {
          # Use the file name relative to `plugins/by-name/`
          name = builtins.head result;
          # Use only the first two parts of the option location
          value = lib.genList (builtins.elemAt opt.loc) 2;
        };
    in
    lib.pipe options [
      (builtins.filter (opt: builtins.length opt.loc == 3 && lib.last opt.loc == "enable"))
      (builtins.concatMap (opt: (builtins.concatMap (optionalPair opt) opt.declarations)))
      builtins.listToAttrs
    ];
in
linkFarmFromDrvs "plugins-by-name" [
  # Ensures all files matching `plugins/by-name/*` are directories
  (runCommandLocal "file-types"
    {
      __structuredAttrs = true;
      inherit (children) regular symlink unknown;
    }
    ''
      declare -i errs=0

      showErrs() {
        type="$1"
        shift

        if (( $# > 0 )); then
          ((++errs))
          echo "Unexpected $type in plugins/by-name ($#):"
          for f in "$@"; do
            echo "  - $f"
          done
          echo
        fi
      }

      showErrs 'symlinks' "''${symlink[@]}"
      showErrs 'regular files' "''${regular[@]}"
      showErrs 'unknown-type files' "''${unknown[@]}"

      if (( $errs > 0 )); then
        exit 1
      fi
      touch $out
    ''
  )

  # Check default.nix files exist for each directory
  (runCommandLocal "default-nix-exists"
    {
      __structuredAttrs = true;
      missingPlugins = builtins.filter (
        name: !(builtins.pathExists "${by-name}/${name}/default.nix")
      ) children.directory;
      missingTests = builtins.filter (
        name: !(builtins.pathExists "${./test-sources/plugins/by-name}/${name}/default.nix")
      ) children.directory;
    }
    ''
      declare -i errs=0

      if (( ''${#missingPlugins[@]} > 0 )); then
        ((++errs))
        echo "The following (''${#missingPlugins[@]}) directories do not have a default.nix file:"
        for name in "''${missingPlugins[@]}"; do
          echo "  - plugins/by-name/$name"
        done
        echo
      fi

      if (( ''${#missingTests[@]} > 0 )); then
        ((++errs))
        echo "The following (''${#missingTests[@]}) test files do not exist:"
        for name in "''${missingTests[@]}"; do
          echo "  - tests/test-sources/plugins/by-name/$name/default.nix"
        done
        echo
      fi

      if (( $errs > 0 )); then
        exit 1
      fi
      touch $out
    ''
  )

  # Ensures all plugin enable options are declared in a directory matching the plugin name
  (runCommandLocal "mismatched-plugin-names"
    {
      __structuredAttrs = true;

      options = lib.pipe by-name-enable-opts [
        (lib.filterAttrs (file: loc: file != lib.last loc))
        (lib.mapAttrs (file: loc: lib.showOption loc))
      ];

      passthru = {
        inherit nixvimConfiguration;
      };
    }
    ''
      if (( ''${#options[@]} > 0 )); then
        echo "Found plugin modules with mismatched option & directory names (''${#options[@]})"
        for file in "''${!options[@]}"; do
          echo "- ''${options[$file]} is declared in '$file'"
        done
        exit 1
      fi
      touch $out
    ''
  )

  # Ensure all plugin enable option are declared under an expected namespace
  (runCommandLocal "unknown-plugin-namespaces"
    {
      __structuredAttrs = true;

      # I'm sorry, I couldn't help implementing oxford-comma...
      expected =
        let
          len = builtins.length knownPluginNamespaces;
        in
        lib.concatImapStringsSep ", " (
          i: str: lib.optionalString (i > 1 && i == len) "or " + "`${str}`"
        ) knownPluginNamespaces;

      options = lib.pipe by-name-enable-opts [
        (lib.filterAttrs (file: loc: !(builtins.elem (builtins.head loc) knownPluginNamespaces)))
        (lib.mapAttrs (file: loc: "`${lib.showOption loc}`"))
      ];

      passthru = {
        inherit nixvimConfiguration;
      };
    }
    ''
      if (( ''${#options[@]} > 0 )); then
        echo "Found plugin modules with unknown option namespaces (''${#options[@]})"
        echo "Expected all plugins to be scoped as $expected"
        for file in "''${!options[@]}"; do
          echo "- ''${options[$file]} is declared in '$file'"
        done
        exit 1
      fi
      touch $out
    ''
  )
]
