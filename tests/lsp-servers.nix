{
  lib,
  nixvimConfiguration,
  stdenv,
  runCommandLocal,
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
        [
          # DEPRECATED SERVERS
          # See https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig.lua
          "ruff_lsp"
          "bufls"
          "typst_lsp"
          # Package ‘dotnet-core-combined’ is marked as insecure, refusing to evaluate.
          # Dotnet SDK 6.0.428 is EOL, please use 8.0 (LTS) or 9.0 (Current)
          # https://github.com/NixOS/nixpkgs/pull/358533
          "dafny"
          "fsautocomplete"
          "omnisharp"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          "fsautocomplete"
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
  runCommandLocal name { } ''
    touch $out
  ''
else
  result.config.build.test
