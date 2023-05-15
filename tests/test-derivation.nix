{
  pkgs,
  makeNixvim,
}: let
  # Create a nix derivation from a nixvim executable.
  # The build phase simply consists in running the provided nvim binary.
  mkTestDerivationFromNvim = {
    name,
    nvim,
    dontRun ? false,
    ...
  }:
    pkgs.stdenv.mkDerivation {
      name = name;

      nativeBuildInputs = [nvim pkgs.docker-client];

      dontUnpack = true;
      # We need to set HOME because neovim will try to create some files
      #
      # Because neovim does not return an exitcode when quitting we need to check if there are
      # errors on stderr
      buildPhase =
        if !dontRun
        then ''
          mkdir -p .cache/nvim

          output=$(HOME=$(realpath .) nvim -mn --headless "+q" 2>&1 >/dev/null)
          if [[ -n $output ]]; then
          	echo "ERROR: $output"
            exit 1
          fi
        ''
        else ''
        '';

      # If we don't do this nix is not happy
      installPhase = ''
        mkdir $out
      '';
    };

  # Create a nix derivation from a nixvim configuration.
  # The build phase simply consists in running neovim with the given configuration.
  mkTestDerivation = name: config: let
    testAttributes =
      if builtins.hasAttr "tests" config
      then config.tests
      else {
        dontRun = false;
      };
    nvim = makeNixvim (pkgs.lib.attrsets.filterAttrs (n: _: n != "tests") config);
  in
    mkTestDerivationFromNvim {
      inherit name nvim;
      inherit (testAttributes) dontRun;
    };
in {
  inherit mkTestDerivation mkTestDerivationFromNvim;
}
