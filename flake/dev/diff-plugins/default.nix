{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      package = pkgs.writers.writePython3Bin "diff-plugins" {
        # Disable flake8 checks that are incompatible with the ruff ones
        flakeIgnore = [
          # Thinks shebang is a block comment
          "E265"
          # line too long
          "E501"
        ];
      } (builtins.readFile ./diff-plugins.py);
    in
    {
      packages.diff-plugins = package;

      devshells.default.commands = [
        {
          name = "diff-plugins";
          command = ''${lib.getExe package} "$@"'';
          help = "Compare available plugins with another nixvim commit";
        }
      ];
    };
}
