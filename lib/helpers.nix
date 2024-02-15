{
  lib,
  pkgs,
  _nixvimTests,
  ...
}: let
  nixvimTypes = import ./types.nix {inherit lib nixvimOptions;};
  nixvimUtils = import ./utils.nix {inherit lib _nixvimTests;};
  nixvimOptions = import ./options.nix {inherit lib nixvimTypes nixvimUtils;};
  inherit (import ./to-lua.nix {inherit lib;}) toLuaObject;
in
  {
    maintainers = import ./maintainers.nix;
    keymaps = import ./keymap-helpers.nix {inherit lib nixvimOptions nixvimTypes;};
    autocmd = import ./autocmd-helpers.nix {inherit lib nixvimOptions nixvimTypes;};
    neovim-plugin = import ./neovim-plugin.nix {inherit lib nixvimOptions toLuaObject;};
    vim-plugin = import ./vim-plugin.nix {inherit lib nixvimOptions;};
    inherit nixvimTypes;
    inherit toLuaObject;
  }
  // nixvimUtils
  // nixvimOptions
