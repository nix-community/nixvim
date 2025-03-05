{
  self,
  inputs,
  helpers,
  ...
}:
{
  perSystem =
    {
      inputs',
      system,
      ...
    }:
    {
      packages = import ../docs {
        nixvim = self;
        inherit helpers;
        inherit system;
        inherit (inputs) nixpkgs;
        inherit (inputs') nuschtosSearch;
      };
    };
}
