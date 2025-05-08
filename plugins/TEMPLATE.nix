{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "my-plugin";
  moduleName = "my-plugin"; # TODO replace (or remove entirely if it is the same as `name`)
  packPathName = "my-plugin.nvim"; # TODO replace (or remove entirely if it is the same as `name`)
  package = "my-plugin-nvim"; # TODO replace

  # TODO replace with your name
  maintainers = [ lib.maintainers.MyName ];

  # TODO provide an example for the `settings` option (or remove entirely if there is no useful example)
  # NOTE you can use `lib.literalExpression` or `lib.literalMD` if needed
  settingsExample = {
    foo = 42;
    bar.__raw = "function() print('hello') end";
  };
}
