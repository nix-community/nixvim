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
          # NOTE: evaluating `helpers` here prints an eval warning
          assertion = builtins.attrNames lib.nixvim == builtins.attrNames helpers;
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
