{lib, ...}: let
  nixvimTypes = import ./types.nix {inherit lib nixvimOptions;};
  nixvimUtils = import ./utils.nix {inherit lib;};
  nixvimOptions = import ./options.nix {inherit lib nixvimTypes nixvimUtils;};
in
  {
    maintainers = import ./maintainers.nix;
    keymaps = import ./keymap-helpers.nix {inherit lib;};
    autocmd = import ./autocmd-helpers.nix {inherit lib;};
    vim-plugin = import ./vim-plugin.nix {inherit lib nixvimOptions;};
    inherit (import ./to-lua.nix {inherit lib;}) toLuaObject;
    inherit nixvimTypes;
  }
  // nixvimUtils
  // nixvimOptions
