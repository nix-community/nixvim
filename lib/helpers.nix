{
  pkgs,
  lib ? pkgs.lib,
  _nixvimTests ? false,
  ...
}:
let
  # Build helpers recursively
  helpers =
    {
      autocmd = import ./autocmd-helpers.nix { inherit lib helpers; };
      keymaps = import ./keymap-helpers.nix { inherit lib helpers; };
      lua = import ./to-lua.nix { inherit lib; };
      toLuaObject = helpers.lua.toLua;
      maintainers = import ./maintainers.nix;
      neovim-plugin = import ./neovim-plugin.nix { inherit lib helpers; };
      nixvimTypes = import ./types.nix { inherit lib helpers; };
      vim-plugin = import ./vim-plugin.nix { inherit lib helpers; };
    }
    // import ./builders.nix { inherit lib pkgs; }
    // import ./deprecation.nix { inherit lib; }
    // import ./options.nix { inherit lib helpers; }
    // import ./utils.nix { inherit lib helpers _nixvimTests; };
in
helpers
