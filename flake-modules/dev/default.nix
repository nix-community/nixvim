{ lib, inputs, ... }:
{
  imports =
    [ ./devshell.nix ]
    ++ lib.optional (inputs.git-hooks ? flakeModule) inputs.git-hooks.flakeModule
    ++ lib.optional (inputs.treefmt-nix ? flakeModule) inputs.treefmt-nix.flakeModule;

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
    lib.optionalAttrs (inputs.treefmt-nix ? flakeModule) {
      treefmt.config = {
        projectRootFile = "flake.nix";

        programs = {
          nixfmt = {
            enable = true;
            package = fmt;
          };
          prettier = {
            enable = true;
            excludes = [ "**.md" ];
          };
          ruff = {
            check = true;
            format = true;
          };
          statix.enable = true;
          stylua.enable = true;
        };

        settings = {
          global.excludes = [
            "LICENSE"
            "flake.lock"
          ];
        };
      };
    }
    // lib.optionalAttrs (inputs.git-hooks ? flakeModule) {
      pre-commit = {
        settings.hooks = {
          treefmt.enable = true;
          typos.enable = true;
        };
      };
    };
}
