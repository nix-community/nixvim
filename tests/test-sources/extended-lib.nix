let
  module =
    { lib, ... }:
    {
      assertions = [
        {
          assertion = lib ? nixvim;
          message = "lib.nixvim should be defined";
        }
      ];
    };
in
{
  top-level = {
    test.buildNixvim = false;
    imports = [ module ];
  };

  files-module = {
    test.buildNixvim = false;
    files."libtest.lua" = module;
  };
}
