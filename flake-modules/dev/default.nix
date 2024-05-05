{ inputs, ... }:
{
  imports = [
    inputs.pre-commit-hooks.flakeModule
    ./devshell.nix
  ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-rfc-style;

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
