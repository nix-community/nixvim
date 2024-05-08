{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lsp.servers.nixd;
in
{
  # Options: https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
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
      command = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[nixpkgs-fmt]" ''
        Which command you would like to do formatting.
        If this option is explicitly set to `["nixpkgs-fmt"]`, `pkgs.nixpkgs-fmt` will automatically be added
        to the nixvim environment.
      '';
    };

    options = helpers.defaultNullOpts.mkNullable (with types; attrsOf (submodule {
      expr = mkOption {
        type = types.str;
        description = ''
          A Nix expression to evaluate to get a set of options.
          For a NixOS configuration with a flake this would be:
          `(builtins.getFlake "/path/to/your/nixos/flake").nixosConfigurations.HOSTNAME.options`
          For a Home-manager configuratino with a flake this would be:
          `(builtins.getFlake "/path/to/your/home-manager/flake").homeConfigurations."USER@HOSTNAME".options`
        '';
      };
    })) "{}" ''
      A set of overrides for where to search for defined `option`s.
    '';
  };

  config = mkIf cfg.enable {
    extraPackages = optional (cfg.settings.formatting.command == ["nixpkgs-fmt"]) pkgs.nixpkgs-fmt;
  };
}
