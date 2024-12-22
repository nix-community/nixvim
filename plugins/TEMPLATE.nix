{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "my-plugin";
  moduleName = "my-plugin"; # TODO replace (or remove entirely if it is the same as `name`)
  packPathName = "my-plugin.nvim"; # TODO replace (or remove entirely if it is the same as `name`)
  package = "my-plugin-nvim"; # TODO replace

  maintainers = [ lib.maintainers.MyName ]; # TODO replace with your name

  # Optionally, explicitly declare some options. You don't have to.
  settingsOptions = {
    foo = defaultNullOpts.mkUnsignedInt 97 ''
      The best birth year.
    '';

    great_feature = defaultNullOpts.mkBool false ''
      Whether to enable the great feature.
    '';
  };

  # Optionally, provide an example for the `settings` option.
  settingsExample = {
    foo = 42;
    bar.__raw = "function() print('hello') end";
  };
}
