{ self, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      package = pkgs.writers.writePython3Bin "generate-all-maintainers" {
        # Disable flake8 checks that are incompatible with the ruff ones
        flakeIgnore = [
          # Thinks shebang is a block comment
          "E265"
          # line too long
          "E501"
          # line break before binary operator
          "W503"
        ];
      } (builtins.readFile ./generate-all-maintainers.py);
    in
    {
      packages.generate-all-maintainers = package;

      checks.generate-all-maintainers-test =
        pkgs.runCommand "generate-all-maintainers-test"
          {
            nativeBuildInputs = [ package ];
          }
          ''
            generate-all-maintainers --root ${self} --output $out
          '';

      devshells.default.commands = [
        {
          name = "generate-all-maintainers";
          command = ''${lib.getExe package} "$@"'';
          help = "Generate a single nix file with all `nixvim` and `nixpkgs` maintainer entries";
        }
      ];
    };
}
