{ lib }:
let
  self = lib.nixvim.plugins;
  call = lib.callPackageWith (self // { inherit call lib self; });
in
{
  utils = call ./utils.nix { };
  neovim = call ./neovim.nix { };
  vim = call ./vim.nix { };

  # Aliases
  inherit (self.neovim) mkNeovimPlugin;
  inherit (self.vim) mkVimPlugin;
}
