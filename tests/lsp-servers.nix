{
  lib,
  nixvimConfiguration,
  stdenv,
  runCommandNoCCLocal,
  name ? "lsp-all-servers",
}:
let
  _file = ./lsp-servers.nix;

  renamed = builtins.attrNames (import ../plugins/lsp/language-servers/_renamed.nix);

  enable-lsp-module = {
    inherit _file;

    plugins.lsp = {
      enable = true;

      servers = {
        hls = {
          installGhc = true;
        };
        rust_analyzer = {
          installCargo = true;
          installRustc = true;
        };
      };
    };
  };

  enable-servers-module =
    {
      lib,
      options,
      pkgs,
      ...
    }:
    let
      disabled =
        lib.optionals pkgs.stdenv.isDarwin [
          "fsautocomplete"
          # typescript-language-server's dependency git-lfs is broken as of 2024-11-03
          "ts_ls"
        ]
        ++ lib.optionals pkgs.stdenv.isAarch64 [
          # Broken
          "scheme_langserver"
        ]
        ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "aarch64-linux") [
          # Binary package not available for this architecture
          "starpls"
          # TODO: 2024-10-05 build failure
          "fstar"
        ]
        ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-darwin") [
          # Binary package not available for this architecture
          "starpls"
        ];
    in
    {
      inherit _file;

      plugins.lsp.servers = lib.pipe options.plugins.lsp.servers [
        (lib.mapAttrs (
          server: opts:
          {
            enable = !(lib.elem server disabled);
          }
          // lib.optionalAttrs (opts ? package && !(opts.package ? default)) { package = null; }
        ))
        (lib.filterAttrs (server: _: !(lib.elem server renamed)))
      ];
    };

  result = nixvimConfiguration.extendModules {
    modules = [
      enable-lsp-module
      enable-servers-module
      { test.name = name; }
    ];
  };
in
# This fails on darwin
# See https://github.com/NixOS/nix/issues/4119
if stdenv.isDarwin then
  runCommandNoCCLocal name { } ''
    touch $out
  ''
else
  result.config.build.test
