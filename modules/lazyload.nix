{
  config,
  lib,
  ...
}:
let
  implementations = [
    "lz-n"
    "lazy"
  ];
in
{
  config = {
    assertions =
      let
        enabled = builtins.filter (x: config.plugins.${x}.enable) implementations;
        count = builtins.length enabled;
      in
      [
        {
          assertion = count < 2;
          message = ''
            You have multiple lazy-loaders enabled:
            ${lib.concatImapStringsSep "\n" (i: x: "${toString i}. plugins.${x}") enabled}
            Please ensure only one is enabled at a time.
          '';
        }
      ];
  };
}
