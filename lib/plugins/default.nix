{ call }:
let
  neovim = call ./neovim.nix { };
  vim = call ./vim.nix { };
in
# TODO: be a bit more deliberate
# NOTE: remove the overridable stuff from `call`;
#       I don't want to think about how (a // b) interacts with them yet
builtins.removeAttrs (neovim // vim) [
  "override"
  "overrideDerivation"
]
