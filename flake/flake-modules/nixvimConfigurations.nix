{ lib, flake-parts-lib, ... }:
let
  configurationType = lib.mkOptionType {
    name = "configuration";
    description = "configuration";
    descriptionClass = "noun";
    merge = lib.options.mergeOneOption;
    check = x: x._type or null == "configuration";
  };
in
flake-parts-lib.mkTransposedPerSystemModule {
  name = "nixvimConfigurations";
  option = lib.mkOption {
    type = lib.types.lazyAttrsOf configurationType;
    default = { };
    description = ''
      An attribute set of Nixvim configurations.
    '';
  };
  file = ./nixvimConfigurations.nix;
}
