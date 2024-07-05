{
  lib,
  nixvimOptions,
  nixvimUtils,
  toLuaObject,
  ...
}:
let
  mkPlugin = import ./mk-plugin.nix { inherit lib nixvimOptions nixvimUtils; };
in
rec {
  plugins = {
    inherit mkPlugin;
    inherit (neovim-plugin) mkNeovimPlugin;
    inherit (vim-plugin) mkVimPlugin;
  };

  neovim-plugin = import ./neovim-plugin.nix {
    inherit
      lib
      nixvimOptions
      nixvimUtils
      toLuaObject
      mkPlugin
      ;
  };

  vim-plugin = import ./vim-plugin.nix {
    inherit
      lib
      nixvimOptions
      nixvimUtils
      mkPlugin
      ;
  };
}
