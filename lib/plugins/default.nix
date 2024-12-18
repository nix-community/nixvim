{
  call,
  lib,
}:
{
  utils = call ./utils.nix { };
  neovim = call ./neovim.nix { };
  vim = call ./vim.nix { };

  # Aliases
  inherit (lib.nixvim.plugins.neovim) mkNeovimPlugin;
  inherit (lib.nixvim.plugins.vim) mkVimPlugin;
}
