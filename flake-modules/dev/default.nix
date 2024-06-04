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
      treefmt.config = {
        inherit (config.flake-root) projectRootFile;
        package = pkgs.treefmt;

        programs = {
          alejandra.enable = true;
          statix.enable = true;
        };
      };

      pre-commit = {
        settings.hooks = {
          alejandra.enable = true;
          statix = {
            enable = true;
            excludes = [ "plugins/lsp/language-servers/rust-analyzer-config.nix" ];
          };
          typos.enable = true;
        };
      };
    };
}
