{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "my-plugin";
  originalName = "my-plugin.nvim"; # TODO replace (or remove entirely if it is the same as `name`)
  defaultPackage = pkgs.vimPlugins.my-plugin-nvim; # TODO replace

  maintainers = [lib.maintainers.MyName]; # TODO replace with your name

  # Optionnally, explicitly declare some options. You don't have to.
  settingsOptions = {
    foo = helpers.defaultNullOpts.mkUnsignedInt 97 ''
      The best birth year.
    '';

    great_feature = helpers.defaultNullOpts.mkBool false ''
      Whether to enable the great feature.
    '';
  };

  # Optionnally, provide an example for the `settings` option.
  settingsExample = {
    foo = 42;
    bar.__raw = "function() print('hello') end";
  };
}
