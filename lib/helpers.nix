{
  pkgs,
  lib ? pkgs.lib,
  _nixvimTests ? false,
  ...
}:
let
  nixvimBuilders = import ./builders.nix { inherit lib pkgs; };
  nixvimTypes = import ./types.nix { inherit lib nixvimOptions; };
  nixvimUtils = import ./utils.nix { inherit lib nixvimTypes _nixvimTests; };
  nixvimOptions = import ./options.nix { inherit lib nixvimTypes nixvimUtils; };
  nixvimDeprecation = import ./deprecation.nix { inherit lib; };
in
rec {
  maintainers = import ./maintainers.nix;
  lua = import ./to-lua.nix { inherit lib; };
  keymaps = import ./keymap-helpers.nix { inherit lib nixvimOptions nixvimTypes; };
  autocmd = import ./autocmd-helpers.nix { inherit lib nixvimOptions nixvimTypes; };
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
  toLuaObject = lua.toLua;
}
// nixvimUtils
// nixvimOptions
// nixvimBuilders
// nixvimDeprecation
