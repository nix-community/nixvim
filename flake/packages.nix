{
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
        inherit helpers;
        inherit system;
        inherit (inputs) nixpkgs;
        inherit (inputs') nuschtosSearch;
      };
    };
}
