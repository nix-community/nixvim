{
  lib,
  pkgs,
  _nixvimTests,
  ...
}:
let
  nixvimBuilders = import ./builders.nix { inherit lib pkgs; };
  nixvimTypes = import ./types.nix { inherit lib nixvimOptions; };
  nixvimUtils = import ./utils.nix { inherit lib _nixvimTests; };
  nixvimOptions = import ./options.nix { inherit lib nixvimTypes nixvimUtils; };
  inherit (import ./to-lua.nix { inherit lib; }) toLuaObject;
in
{
  maintainers = import ./maintainers.nix;
  keymaps = import ./keymap-helpers.nix { inherit lib nixvimOptions nixvimTypes; };
  autocmd = import ./autocmd-helpers.nix { inherit lib nixvimOptions nixvimTypes; };
  deprecation = import ./deprecation-helpers.nix { inherit lib nixvimUtils; };
  neovim-plugin = import ./neovim-plugin.nix {
    inherit
      lib
      nixvimOptions
      nixvimUtils
      toLuaObject
      ;
  };
  vim-plugin = import ./vim-plugin.nix { inherit lib nixvimOptions nixvimUtils; };
  inherit nixvimTypes;
  inherit toLuaObject;
}
// nixvimUtils
// nixvimOptions
// nixvimBuilders
