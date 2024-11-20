{
  perSystem =
    { pkgs, ... }:
    {
      apps.ci-new-plugin-matrix.program = pkgs.writers.writePython3Bin "test_python3" {
        libraries = with pkgs.python3Packages; [
          requests
        ];
        flakeIgnore = [
          "E501" # Line length
          "W503" # Line break before binary operator
        ];
      } (builtins.readFile ./ci-new-plugin-matrix.py);
    };
}
