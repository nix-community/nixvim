{
  lib,
  config,
  pkgs,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin config {
  name = "my-plugin";
  originalName = "my-plugin.nvim"; # TODO replace (or remove entirely if it is the same as `name`)
  defaultPackage = pkgs.vimPlugins.my-plugin-nvim; # TODO replace

  maintainers = [ lib.maintainers.MyName ]; # TODO replace with your name

  # Optionally, explicitly declare some options. You don't have to.
  settingsOptions = {
    foo = lib.nixvim.defaultNullOpts.mkUnsignedInt 97 ''
      The best birth year.
    '';

    great_feature = lib.nixvim.defaultNullOpts.mkBool false ''
      Whether to enable the great feature.
    '';
  };

  # Optionally, provide an example for the `settings` option.
  settingsExample = {
    foo = 42;
    bar.__raw = "function() print('hello') end";
  };
}
