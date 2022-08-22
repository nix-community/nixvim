{ lib, config, pkgs, ... }:

with lib;
with types;
let

  helpers = import ../../../helpers.nix { inherit lib config; };

  luaSnipOptions = submodule {
    options = {
      enable = mkEnableOption "";
    };
  };
  

in mkOption {
  type = submodule {
    options = {
      luasnip = mkOption {
        type = luaSnipOptions;
      };
    };
  };
}
