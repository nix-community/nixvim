{
  nixvimConfiguration,
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
      ...
    }:
    let

      disabled = [
        # TODO: 2025-07-25 python313Packages.lsp-tree-sitter marked as broken
        "autotools_ls"

        # TODO: 2025-07-25 build failure
        "mint"
        "nextls"
        "ts_query_ls"

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
