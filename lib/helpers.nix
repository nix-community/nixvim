{
  pkgs,
  lib ? pkgs.lib,
  _nixvimTests ? false,
  ...
}:
let
  # Used when importing parts of helpers
  call = lib.callPackageWith { inherit pkgs lib helpers; };

  # Build helpers recursively
  helpers =
    {
      autocmd = call ./autocmd-helpers.nix { };
      keymaps = call ./keymap-helpers.nix { };
      lua = call ./to-lua.nix { };
      toLuaObject = helpers.lua.toLua;
      maintainers = import ./maintainers.nix;
      neovim-plugin = call ./neovim-plugin.nix { };
      nixvimTypes = call ./types.nix { };
      vim-plugin = call ./vim-plugin.nix { };
    }
    // call ./builders.nix { }
    // call ./deprecation.nix { }
    // call ./options.nix { }
    // call ./utils.nix { inherit _nixvimTests; };
in
helpers
