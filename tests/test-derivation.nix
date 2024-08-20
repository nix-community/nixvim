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
      nvim,
      # TODO: Deprecated 2024-08-20, remove after 24.11
      dontRun ? false,
      ...
    }@args:
    let
      result = nvim.extend { isTest = true; };
      cfg = result.config.test;
      runNvim =
        lib.warnIf (args ? dontRun)
          "mkTestDerivationFromNvim: the `dontRun` argument is deprecated. You should use the `test.runNvim` module option instead."
          (cfg.runNvim && !dontRun);
    in
    pkgs.stdenv.mkDerivation {
      inherit name;

      nativeBuildInputs = [
        result
        pkgs.docker-client
      ];

      dontUnpack = true;
      # We need to set HOME because neovim will try to create some files
      #
      # Because neovim does not return an exitcode when quitting we need to check if there are
      # errors on stderr
      buildPhase = lib.optionalString runNvim ''
        mkdir -p .cache/nvim

        output=$(HOME=$(realpath .) nvim -mn --headless "+q" 2>&1 >/dev/null)
        if [[ -n $output ]]; then
            echo "ERROR: $output"
          exit 1
        fi
      '';

      # If we don't do this nix is not happy
      installPhase = ''
        mkdir $out
      '';
    };

  # Create a nix derivation from a nixvim configuration.
  # The build phase simply consists in running neovim with the given configuration.
  mkTestDerivationFromNixvimModule =
    {
      name ? "nixvim-check",
      pkgs ? pkgs,
      module,
      extraSpecialArgs ? { },
      # TODO: Deprecated 2024-08-20, remove after 24.11
      dontRun ? false,
    }@args:
    let
      nvim = makeNixvimWithModule {
        inherit pkgs extraSpecialArgs;
        module =
          if args ? dontRun then
            lib.warn
              "mkTestDerivationFromNixvimModule: the `dontRun` argument is deprecated. You should use the `test.runNvim` module option instead."
              {
                imports = [ module ];
                config.test.runNvim = !dontRun;
              }
          else
            module;
      };
    in
    mkTestDerivationFromNvim { inherit name nvim; };
in
{
  inherit mkTestDerivationFromNvim mkTestDerivationFromNixvimModule;
}
