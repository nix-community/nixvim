{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
    ./devshell.nix
  ];

  perSystem =
    { pkgs, config, ... }:
    let
      fmt = pkgs.nixfmt-rfc-style;
    in
    {
      treefmt.config = {
        projectRootFile = "flake.nix";

        programs = {
          nixfmt = {
            enable = true;
            package = fmt;
          };
          statix.enable = true;
        };
      };

      pre-commit = {
        settings.hooks = {
          nixfmt = {
            enable = true;
            package = fmt;
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
