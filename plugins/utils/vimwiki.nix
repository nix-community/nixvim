{ lib, pkgs, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "vimwiki";
  description = "Enable vimwiki.vim";
  extraPlugins = [ pkgs.vimPlugins.vimwiki ];
}
