{
  lib,
  nixvimConfiguration,
  name ? "lsp-all-servers",
}:
let
  _file = ./lsp-servers.nix;

  unsupported =
    builtins.attrNames (import ../plugins/lsp/language-servers/_renamed.nix)
    ++ lib.importJSON ../generated/unsupported-lspconfig-servers.json;

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
      ...
    }:
    let

      disabled = [
        # TODO: 2025-07-25 build failure
        "mint"

        # DEPRECATED SERVERS
        # See https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig.lua
        "ruff_lsp"
        "bufls"
        "typst_lsp"
      ];
    in
    {
      inherit _file;

      plugins.lsp.servers = lib.pipe options.plugins.lsp.servers [
        (lib.mapAttrs (
          server: opts:
          let
            # Some servers are defined using mkUnpackagedOption whose default will throw
            pkg = builtins.tryEval opts.package.default;
            hasPkg = opts ? package.default && pkg.success;
            isUnfree = pkg.value.meta.unfree or false;
            isDisabled = lib.elem server disabled;
          in
          {
            enable = !isDisabled;
          }
          // lib.optionalAttrs (hasPkg -> isUnfree) {
            package = null;
          }
        ))
        (lib.filterAttrs (server: _: !(lib.elem server unsupported)))
      ];

      # TODO 2025-10-01
      # Calls `require("lspconfig")` which is deprecated, producing a warning
      plugins.idris2.enable = false;
    };

  result = nixvimConfiguration.extendModules {
    modules = [
      enable-lsp-module
      enable-servers-module
      { test.name = name; }
    ];
  };
in
result.config.build.test
