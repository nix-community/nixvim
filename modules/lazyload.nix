{
  config,
  lib,
  options,
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
      lib.optionals (count > 0) [
        ''
          You have enabled experimental lazy loading support.
          ${lib.concatImapStringsSep "\n" (i: x: "${toString i}. plugins.${x}") pluginsWithLazyLoad}
          This is not a stable API and may have breaking changes.
        ''
      ];
  };
}
