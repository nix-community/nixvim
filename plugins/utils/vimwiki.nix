{ lib, pkgs, config, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit lib config; };
in with helpers; with lib;
mkPlugin attrs {
  name = "vimwiki";
  description = "Enable vimwiki.vim";
  extraPlugins = [ pkgs.vimPlugins.vimwiki ];
}
