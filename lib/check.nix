{pkgs, ...}: {
  checkNvim = {
    name,
    nvim,
    dontRun,
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
}
