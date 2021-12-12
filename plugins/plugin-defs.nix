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
  mark-radar = pkgs.vimUtils.buildVimPlugin rec {
    pname = "mark-radar";
    version = "d7fb84a670795a5b36b18a5b59afd1d3865cbec7";
    src = pkgs.fetchFromGitHub {
      owner = "winston0410";
      repo = "mark-radar.nvim";
      rev = version;
      sha256 = "1y3l2c7h8czhw0b5m25iyjdyy0p4nqk4a3bxv583m72hn4ac8rz9";
    };
  };
}
