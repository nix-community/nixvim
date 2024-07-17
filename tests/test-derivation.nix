{
  pkgs,
<<<<<<< HEAD
  makeNixvim,
  makeNixvimWithModule,
=======
  lib ? pkgs.lib,
  makeNixvimWithModule,
  ...
>>>>>>> 71126bfe (tests: Allow to test multiple derivations in a single test derivation)
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
        ''
        + lib.concatStringsSep "\n" (
          builtins.map (
            {
              derivation,
              name,
              dontRun ? false,
            }:
            lib.optionalString (!dontRun) ''
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

      # If we don't do this nix is not happy
      installPhase = ''
        mkdir $out
      '';
    };

  mkTestDerivationFromNixvimModule =
    {
      name ? "nixvim-check",
<<<<<<< HEAD
      pkgs,
      module,
=======
      pkgs ? pkgs,
      module ? null,
      tests ? [ ],
>>>>>>> 71126bfe (tests: Allow to test multiple derivations in a single test derivation)
      extraSpecialArgs ? { },
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
<<<<<<< HEAD
    mkTestDerivationFromNvim { inherit name nvim; };

  # Create a nix derivation from a nixvim configuration.
  # The build phase simply consists in running neovim with the given configuration.
  mkTestDerivation =
    name: config:
    let
      testAttributes = if builtins.hasAttr "tests" config then config.tests else { dontRun = false; };
      nvim = makeNixvim (pkgs.lib.attrsets.filterAttrs (n: _: n != "tests") config);
    in
    mkTestDerivationFromNvim {
      inherit name nvim;
      inherit (testAttributes) dontRun;
=======
    mkTestDerivationFromNvim {
      inherit name dontRun;
      tests = testDerivations;
>>>>>>> 71126bfe (tests: Allow to test multiple derivations in a single test derivation)
    };
in
{
  inherit mkTestDerivation mkTestDerivationFromNvim mkTestDerivationFromNixvimModule;
}
