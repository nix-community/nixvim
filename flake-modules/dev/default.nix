{ lib, inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    ./devshell.nix
  ] ++ lib.optional (inputs.git-hooks ? flakeModule) inputs.git-hooks.flakeModule;

  perSystem =
    {
      lib,
      pkgs,
      config,
      ...
    }:
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
    }
    // lib.optionalAttrs (inputs.git-hooks ? flakeModule) {
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
