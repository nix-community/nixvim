{ lib, ... }:
# This plugin has no configuration, so we use `mkVimPlugin` without the `globalPrefix` argument to
# avoid the creation of the `settings` option.
lib.nixvim.plugins.mkVimPlugin {
  name = "texpresso";
  package = "texpresso-vim";
  description = "Neovim mode for TeXpresso.";

  maintainers = [ lib.maintainers.nickhu ];

  dependencies = [ "texpresso" ];
}
