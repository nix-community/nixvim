{
  lib,
  pkgs,
  _nixvimTests,
  ...
}:
let
  nixvimBuilders = import ./builders.nix { inherit lib pkgs; };
  nixvimTypes = import ./types.nix { inherit lib nixvimOptions; };
  nixvimUtils = import ./utils.nix { inherit lib nixvimTypes _nixvimTests; };
  nixvimOptions = import ./options.nix { inherit lib nixvimTypes nixvimUtils; };
  nixvimDeprecation = import ./deprecation.nix { inherit lib; };
  lua = import ./to-lua.nix { inherit lib; };
  toLuaObject = lua.toLua;
  nixvimPlugins = import ./plugins {
    inherit
      lib
      nixvimOptions
      nixvimUtils
      toLuaObject
      ;
  };
in
rec {
  maintainers = import ./maintainers.nix;
  keymaps = import ./keymap-helpers.nix { inherit lib nixvimOptions nixvimTypes; };
  autocmd = import ./autocmd-helpers.nix { inherit lib nixvimOptions nixvimTypes; };
  plugins = import ./plugin { };
  inherit nixvimTypes lua toLuaObject;
}
// nixvimUtils
// nixvimOptions
// nixvimBuilders
// nixvimDeprecation
// nixvimPlugins
