{
  name,
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    plugin = lib.mkOption {
      type = lib.types.package;
      description = "A derivation with the content of the file in it";
      readOnly = true;
      internal = true;
    };
  };
  config = {
    path = name;
    type = lib.mkDefault (if lib.hasSuffix ".vim" name then "vim" else "lua");
    plugin = pkgs.writeTextDir config.path config.content;
  };
}
