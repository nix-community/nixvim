{
  self,
  inputs,
  helpers,
  ...
}:
{
  perSystem =
    {
      config,
      inputs',
      system,
      ...
    }:
    {
      # Run the docs server when using `nix run .#docs`
      apps.docs.program = config.packages.serve-docs;

      packages = import ../docs {
        nixvim = self;
        inherit helpers;
        inherit system;
        inherit (inputs) nixpkgs;
        inherit (inputs') nuschtosSearch;
      };
    };
}
