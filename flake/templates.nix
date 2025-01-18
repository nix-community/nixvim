{ self, inputs, ... }:
{
  flake.templates = {
    default = {
      path = ../templates/simple;
      description = "A simple nix flake template for getting started with nixvim";
    };
    new = {
      path = ../templates/experimental-flake-parts;
      description = "An experimental flake template for configuring nixvim using evalNixvim and flake.parts";
    };
  };

  # The following adds the template flake's checks to the main (current) flake's checks.
  # It ensures that the template's own checks are successful.
  perSystem =
    {
      pkgs,
      system,
      lib,
      ...
    }:
    {
      checks =
        let
          # Approximates https://github.com/NixOS/nix/blob/7cd08ae379746749506f2e33c3baeb49b58299b8/src/libexpr/flake/call-flake.nix#L46
          # s/flake.outputs/args.outputs/
          callFlake =
            args@{
              inputs,
              outputs,
              sourceInfo ? { },
            }:
            let
              outputs = args.outputs (inputs // { self = result; });
              result =
                outputs
                // sourceInfo
                // {
                  inherit inputs outputs sourceInfo;
                  _type = "flake";
                };
            in
            result;

          flakes = lib.mapAttrs (
            name: template:
            callFlake {
              # Use inputs from our flake
              inputs = {
                inherit (inputs) flake-parts nixpkgs;
                nixvim = self;
              };
              # Use outputs from the template flake
              inherit (import "${template.path}/flake.nix") outputs;
            }
          ) self.templates;
        in
        lib.concatMapAttrs (name: flake: {
          "template-${name}" = pkgs.linkFarm name flake.checks.${system};
        }) flakes;
    };
}
