{ inputs, self, ... }:
{
  perSystem =
    {
      self',
      config,
      lib,
      inputs',
      system,
      pkgs,
      ...
    }:
    let
      package = pkgs.writers.writePython3Bin "list-plugins" {
        # Disable flake8 checks that are incompatible with the ruff ones
        flakeIgnore = [
          # line too long
          "E501"
          # line break before binary operator
          "W503"
        ];
      } (builtins.readFile ./list-plugins.py);
    in
    {
      packages.list-plugins = package;

      checks.list-plugins-test =
        pkgs.runCommand "list-plugins-test"
          {
            nativeBuildInputs = [ package ];
          }
          ''
            list-plugins --root-path ${self} > $out
          '';

    }
    // lib.optionalAttrs (inputs.devshell ? flakeModule) {
      devshells.default.commands = [
        {
          name = "list-plugins";
          command = ''${lib.getExe package} "$@"'';
          help = "List plugins and get implementation infos";
        }
      ];
    };
}
