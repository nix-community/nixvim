{
  self,
  config,
  inputs,
  ...
}:
let
  # We use a flake input from the dev flake so that this doesn't end up in users' lockfiles.
  inherit (config.partitions.dev.module.inputs) nuschtosSearch;
in
{
  perSystem =
    {
      config,
      system,
      ...
    }:
    {
      # Run the docs server when using `nix run .#docs`
      apps.docs.program = config.packages.serve-docs;

      packages = import ../docs {
        nixvim = self;
        inherit system;
        inherit (inputs) nixpkgs;
        mkNuschtosSearch = nuschtosSearch.packages.${system}.mkSearch;
      };
    };
}
