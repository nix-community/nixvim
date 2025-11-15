{
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
      inherit (pkgs.stdenv) hostPlatform;

      disabled = [
        # DEPRECATED SERVERS
        # See https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig.lua
        "ruff_lsp"
        "bufls"
        "typst_lsp"
      ]
      ++ lib.optionals (hostPlatform.isLinux && hostPlatform.isAarch64) [
        # TODO: 2025-04-20 build failure (swift-corelibs-xctest)
        "sourcekit"

        # pkgs.vectorcode is not available on this platform
        "vectorcode_server"

        # TODO: 2024-10-05 build failure
        "fstar"

        # TODO: 2025-03-04 marked as broken
        "nickel_ls"
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
          # Some servers are defined using mkUnpackagedOption whose default will throw
          // lib.optionalAttrs (opts ? package && !(builtins.tryEval opts.package.default).success) {
            package = null;
          }
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
