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
  config =
    let
      derivationName = "nvim-" + lib.replaceStrings [ "/" ] [ "-" ] name;
    in
    {
      path = lib.mkDefault name;
      type = lib.mkDefault (if lib.hasSuffix ".vim" name then "vim" else "lua");
      # No need to use mkDerivedConfig; this option is readOnly.
      plugin = pkgs.writeText derivationName config.content;
    };
}
