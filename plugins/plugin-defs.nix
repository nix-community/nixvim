# This is for plugins not in nixpkgs
# e.g. intellitab.nvim
# Ideally, in the future, this would all be specified as a flake input!
{ pkgs, ... }:
{
  intellitab-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "intellitab-nvim";
    version = "a6c1a505865f6131866d609c52440306e9914b16";
    src = pkgs.fetchFromGitHub {
      owner = "pta2002";
      repo = "intellitab.nvim";
      rev = version;
      sha256 = "19my464jsji7cb81h0agflzb0vmmb3f5kapv0wwhpdddcfzvp4fg";
    };
  };
}
