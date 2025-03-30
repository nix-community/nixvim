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
    warnings =
      let
        ignoredPackages = [
          # removed
          "packer"
          "treesitter-playground"
          # renamed
          "surround"
          "null-ls"
          "wilder-nvim"
        ];

        pluginsWithLazyLoad = builtins.filter (
          x:
          !(lib.elem x ignoredPackages)
          && lib.hasAttr "lazyLoad" config.plugins.${x}
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
