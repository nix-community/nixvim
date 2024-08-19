let
  module =
    { lib, helpers, ... }:
    {
      assertions = [
        {
          assertion = lib ? nixvim;
          message = "lib.nixvim should be defined";
        }
        {
          assertion = lib.nixvim == helpers;
          message = "lib.nixvim and helpers should be aliases";
        }
      ];
    };
in
{
  top-level = module;

  files-module = {
    files."libtest.lua" = module;
  };
}
