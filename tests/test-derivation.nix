{
  pkgs,
  lib ? pkgs.lib,
  makeNixvimWithModule,
  ...
}:
let
  # Create a nix derivation from a nixvim executable.
  # The build phase simply consists in running the provided nvim binary.
  mkTestDerivationFromNvim =
    {
      name,
      nvim ? null,
      tests ? [ ],
      dontRun ? false,
      ...
    }:
    # At least one of these should be undefined
    assert lib.assertMsg (tests == [ ] || nvim == null) "Both nvim & tests can't be supplied";
    let
      nvimAsList = lib.optional (nvim != null) {
        derivation = nvim;
        inherit name dontRun;
      };

      testList = tests ++ nvimAsList;
    in
    pkgs.stdenv.mkDerivation {
      inherit name;

      nativeBuildInputs = [ pkgs.docker-client ];

      dontUnpack = true;
      # We need to set HOME because neovim will try to create some files
      #
      # Because neovim does not return an exitcode when quitting we need to check if there are
      # errors on stderr
      buildPhase = lib.optionalString (!dontRun) (
        ''
          mkdir -p .cache/nvim
          mkdir $out
        ''
        + lib.concatStringsSep "\n" (
          builtins.map (
            {
              derivation,
              name,
              dontRun ? false,
            }:
            lib.optionalString (!dontRun) ''
              ln -s ${derivation} $out/${name}

              echo "Running test for ${name}"

              output=$(HOME=$(realpath .) ${lib.getExe derivation} -mn --headless "+q" 2>&1 >/dev/null)
              if [[ -n $output ]]; then
                echo "ERROR: $output"
                exit 1
              fi
            ''
          ) testList
        )
      );
    };

  # Create a nix derivation from a nixvim configuration.
  # The build phase simply consists in running neovim with the given configuration.
  mkTestDerivationFromNixvimModule =
    {
      name ? "nixvim-check",
      pkgs ? pkgs,
      module ? null,
      tests ? [ ],
      extraSpecialArgs ? { },
      dontRun ? false,
    }:
    # At least one of these should be undefined
    assert lib.assertMsg (tests == [ ] || module == null) "Both module & tests can't be supplied";
    let
      moduleAsList = lib.optional (module != null) { inherit module name; };
      moduleList = tests ++ moduleAsList;
      testDerivations = builtins.map (
        {
          module,
          name,
          dontRun ? false,
        }:
        {
          derivation = makeNixvimWithModule {
            inherit pkgs module extraSpecialArgs;
            _nixvimTests = true;
          };
          inherit name dontRun;
        }
      ) moduleList;
    in
    mkTestDerivationFromNvim {
      inherit name dontRun;
      tests = testDerivations;
    };
in
{
  inherit mkTestDerivationFromNvim mkTestDerivationFromNixvimModule;
}
