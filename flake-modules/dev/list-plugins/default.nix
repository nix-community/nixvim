{
  perSystem =
    {
      config,
      lib,
      inputs',
      system,
      pkgs,
      ...
    }:
    {
      packages.list-plugins = pkgs.writers.writePython3Bin "list-plugins" {
        # Disable flake8 checks that are incompatible with the ruff ones
        flakeIgnore = [
          # line too long
          "E501"
          # line break before binary operator
          "W503"
        ];
      } (builtins.readFile ./list-plugins.py);

      devshells.default.commands = [
        {
          name = "list-plugins";
          command = ''${lib.getExe config.packages.list-plugins} "$@"'';
          help = "List plugins and get implementation infos";
        }
      ];
    };
}
