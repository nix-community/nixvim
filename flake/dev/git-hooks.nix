{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      system,
      ...
    }:
    {
      pre-commit = {
        # We have a treefmt check already, so this is redundant.
        # We also can't run the test if it includes running `nix build`,
        # since the nix CLI can't build within a derivation builder.
        check.enable = false;

        settings.hooks = {
          deadnix = {
            enable = true;

            settings = {
              noLambdaArg = true;
              noLambdaPatternNames = true;
              edit = true;
            };
          };
          treefmt = {
            enable = true;
            package = config.formatter;
          };
          typos = {
            enable = true;
            excludes = [ "generated/*" ];
          };
          maintainers = {
            enable = true;
            name = "maintainers";
            description = "Check maintainers when it is modified.";
            files = "^lib/maintainers[.]nix$";
            package = pkgs.nix;
            entry = "nix build --no-link --print-build-logs";
            args = [ ".#checks.${system}.maintainers" ];
            pass_filenames = false;
          };
          plugins-by-name = {
            enable = true;
            name = "plugins-by-name";
            description = "Check `plugins/by-name` when it's modified.";
            files = "^(?:tests/test-sources/)?plugins/by-name/";
            package = pkgs.nix;
            entry = "nix build --no-link --print-build-logs";
            args = [ ".#checks.${system}.plugins-by-name" ];
            pass_filenames = false;
          };
        };
      };
    };
}
