{
  lib,
  nixvimOptions,
}:
with lib; {
  extraOptionsOptions = {
    extraOptions = mkOption {
      default = {};
      type = with types; attrsOf anything;
      description = ''
        These attributes will be added to the table parameter for the setup function.
        (Can override other attributes set by nixvim)
      '';
    };
  };
}
