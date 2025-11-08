{
  config,
  options,
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
    warnings =
      let
        isVisible =
          opt:
          let
            visible = opt.visible or true;
          in
          if lib.isBool visible then visible else visible == "shallow";

        pluginsWithLazyLoad = builtins.filter (
          x:
          lib.isOption (options.plugins.${x}.lazyload or null)
          && isVisible options.plugins.${x}.lazyload
          && config.plugins.${x}.lazyLoad.enable
        ) (builtins.attrNames config.plugins);
        count = builtins.length pluginsWithLazyLoad;
      in
      lib.nixvim.mkWarnings "lazy loading" {
        when = count > 0 && !config.plugins.lz-n.enable;

        message = ''
          You have enabled lazy loading support for the following plugins but have not enabled a lazy loading provider.
            ${lib.concatImapStringsSep "\n" (i: x: "${toString i}. plugins.${x}") pluginsWithLazyLoad}

          Currently supported lazy providers:
            - lz-n
        '';
      };
  };
}
