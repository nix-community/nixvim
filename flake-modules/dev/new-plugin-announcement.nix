{
  perSystem =
    { pkgs, ... }:
    {
      apps.new-plugin-msg.program = pkgs.writers.writePython3Bin "new-plugin-announcement" {
        libraries = with pkgs.python3Packages; [
          requests
        ];
        flakeIgnore = [
          "E501" # Line length
          "W503" # Line break before binary operator
        ];
      } (builtins.readFile ./new-plugin-announcement.py);
    };
}
