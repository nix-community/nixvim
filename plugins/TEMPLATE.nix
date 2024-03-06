{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "my-plugin";
  originalName = "my-plugin.nvim";
  defaultPackage = pkgs.vimPlugins.my-plugin-nvim; # TODO replace

  # Optionally provide an example for the `settings` option.
  settingsExample = {
    foo = 42;
    bar.__raw = "function() print('hello') end";
  };

  maintainers = [lib.maintainers.MyName]; # TODO replace with your name
}
