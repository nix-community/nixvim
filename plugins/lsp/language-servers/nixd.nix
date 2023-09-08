{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  helpers = import ../../helpers.nix {inherit lib;};
  cfg = config.plugins.lsp.servers.nixd;
in {
  # Options: https://github.com/nix-community/nixd/blob/main/docs/user-guide.md#configuration
  options.plugins.lsp.servers.nixd.settings = {
    # The evaluation section, provide auto completion for dynamic bindings.
    eval = {
      target = {
        args = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
          Accept args as "nix eval".
        '';

        installable = helpers.defaultNullOpts.mkStr "" ''
          "nix eval"
        '';
      };

      depth = helpers.defaultNullOpts.mkInt 0 "Extra depth for evaluation";

      workers = helpers.defaultNullOpts.mkInt 3 "The number of workers for evaluation task.";
    };

    formatting = {
      command = helpers.defaultNullOpts.mkStr "nixpkgs-fmt" ''
        Which command you would like to do formatting.
        Explicitly set to `"nixpkgs-fmt"` will automatically add `pkgs.nixpkgs-fmt` to the nixvim
        environment.
      '';
    };

    options = {
      enable = helpers.defaultNullOpts.mkBool true ''
        Enable option completion task.
        If you are writting a package, disable this
      '';

      target = {
        args = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
          Accept args as "nix eval".
        '';

        installable = helpers.defaultNullOpts.mkStr "" ''
          "nix eval"
        '';
      };
    };
  };

  config =
    mkIf cfg.enable
    {
      extraPackages =
        optional
        (cfg.settings.formatting.command == "nixpkgs-fmt")
        pkgs.nixpkgs-fmt;
    };
}
