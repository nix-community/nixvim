{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
    ./devshell.nix
  ];

  perSystem =
    { pkgs, config, ... }:
    {
      formatter = config.treefmt.build.wrapper;

      treefmt.config = {
        projectRootFile = "flake.nix";
        package = pkgs.treefmt;

        programs = {
          nixfmt-rfc-style.enable = true;
          statix.enable = true;
        };
      };

      pre-commit = {
        settings.hooks = {
          nixfmt = {
            package = pkgs.nixfmt-rfc-style;
            enable = true;
          };
          statix = {
            enable = true;
            excludes = [ "plugins/lsp/language-servers/rust-analyzer-config.nix" ];
          };
          typos.enable = true;
        };
      };
    };
}
