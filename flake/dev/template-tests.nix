{ self, inputs, ... }:
{
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
          # Approximates https://github.com/NixOS/nix/blob/96e550ef/src/libexpr/call-flake.nix#L67-L85
          callFlake =
            flake@{
              inputs,
              outputs,
              sourceInfo ? { },
            }:
            let
              outputs = flake.outputs (inputs // { self = result; });
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
