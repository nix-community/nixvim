{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "vim-be-good";
  package = "vim-be-good";

  description = ''
    Vim be good is a plugin designed to make you better at vim by creating a game to practice basic movements in.
    Learn more: https://github.com/ThePrimeagen/vim-be-good
  '';

  maintainers = [ lib.maintainers.KatieJanzen ];

  callSetup = false;
  hasSettings = false;
}
