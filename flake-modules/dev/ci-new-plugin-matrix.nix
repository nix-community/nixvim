{
  perSystem =
    { pkgs, ... }:
    {
      apps.plugin-info.program = pkgs.writers.writePython3Bin "test_python3" {
        libraries = with pkgs.python3Packages; [ ];
        flakeIgnore = [
          "E501" # Line length
        ];
      } (builtins.readFile ./ci-new-plugin-matrix.py);
    };
}
