{
  lib,
  pkgs,
  ...
}:
let
  renamedServers = import ./_renamed.nix;
  unsupportedServers = lib.importJSON ../../../generated/unsupported-lspconfig-servers.json;

  inherit (lib) mkOption types;

  lspExtraArgs = {
    dartls = {
      settings = cfg: { dart = cfg; };
    };
    gopls = {
      extraConfig = {
        dependencies.go.enable = lib.mkDefault true;
      };
    };
    idris2_lsp = {
      extraConfig = {
        plugins.idris2.enable = lib.mkDefault true;
      };
    };
    jsonls = {
      settings = cfg: { json = cfg; };
    };
    ltex = {
      settings = cfg: { ltex = cfg; };
    };
    lua_ls = {
      settings = cfg: { Lua = cfg; };
    };
    nil_ls = {
      settings = cfg: { nil = cfg; };
    };
    nixd = {
      settings = cfg: { nixd = cfg; };
      extraConfig = cfg: {
        extraPackages = lib.optional (
          (cfg.settings.formatting.command or null) == [ "nixpkgs-fmt" ]
        ) pkgs.nixpkgs-fmt;
      };
    };
    omnisharp = {
      settings = cfg: { omnisharp = cfg; };
    };
    pylsp = {
      settings = cfg: { pylsp = cfg; };
    };
    rust_analyzer = {
      settings = cfg: { rust-analyzer = cfg; };
    };
    ts_ls = {
      # NOTE: Provide the plugin default filetypes so that
      # `plugins.lsp.servers.volar.tslsIntegration` and `plugins.lsp.servers.vue_ls.tslsIntegration` don't wipe out the default filetypes
      extraConfig = {
        plugins.lsp.servers.ts_ls = {
          filetypes = [
            "javascript"
            "javascriptreact"
            "javascript.jsx"
            "typescript"
            "typescriptreact"
            "typescript.tsx"
          ];
        };
      };
    };
    vue_ls = {
      extraOptions = {
        tslsIntegration = mkOption {
          type = types.bool;
          description = ''
            Enable integration with TypeScript language server.
          '';
          default = true;
          example = false;
        };
      };
      extraConfig = cfg: opts: {
        assertions = lib.nixvim.mkAssertions "plugins.lsp.servers.vue_ls" {
          assertion = cfg.tslsIntegration -> (cfg.package != null);
          message = "When `${opts.tslsIntegration}` is enabled, `${opts.package}` must not be null.";
        };
        plugins.lsp.servers.ts_ls = lib.mkIf (cfg.enable && cfg.tslsIntegration) {
          filetypes = [ "vue" ];
          extraOptions = {
            init_options = {
              plugins = lib.mkIf (cfg.package != null) [
                {
                  name = "@vue/typescript-plugin";
                  location = "${lib.getBin cfg.package}/lib/language-tools/packages/language-server";
                  languages = [ "vue" ];
                }
              ];
            };
          };
        };
      };
    };
    vls = {
      extraOptions = {
        autoSetFiletype = mkOption {
          type = types.bool;
          description = ''
            Files with the `.v` extension are not automatically detected as vlang files.
            If this option is enabled, Nixvim will automatically set the filetype accordingly.
          '';
          default = true;
          example = false;
        };
      };
      extraConfig = cfg: {
        filetype.extension = lib.mkIf (cfg.enable && cfg.autoSetFiletype) { v = "vlang"; };
      };
    };
    volar = {
      extraOptions = {
        tslsIntegration = mkOption {
          type = types.bool;
          description = ''
            Enable integration with TypeScript language server.
          '';
          default = true;
          example = false;
        };
      };
      extraConfig = cfg: opts: {
        assertions = lib.nixvim.mkAssertions "plugins.lsp.servers.volar" {
          assertion = cfg.tslsIntegration -> (cfg.package != null);
          message = "When `${opts.tslsIntegration}` is enabled, `${opts.package}` must not be null.";
        };
        plugins.lsp.servers.ts_ls = lib.mkIf (cfg.enable && cfg.tslsIntegration) {
          filetypes = [ "vue" ];
          extraOptions = {
            init_options = {
              plugins = lib.mkIf (cfg.package != null) [
                {
                  name = "@vue/typescript-plugin";
                  location = "${lib.getBin cfg.package}/lib/language-tools/packages/language-server";
                  languages = [ "vue" ];
                }
              ];
            };
          };
        };
      };
    };
    yamlls = {
      settings = cfg: { yaml = cfg; };
    };
  };

  lspPackages = import ../../../modules/lsp/servers/packages.nix;

  generatedServers = lib.pipe ../../../generated/lspconfig-servers.json [
    lib.importJSON
    (lib.mapAttrsToList (
      name: description:
      {
        inherit name description;
      }
      // lib.optionalAttrs (lspPackages.packages ? ${name}) {
        package = lspPackages.packages.${name};
      }
      // lspExtraArgs.${name} or { }
    ))
  ];
in
{
  imports =
    let
      mkLsp = import ./_mk-lsp.nix;
      lspModules = map mkLsp generatedServers;
      baseLspPath = [
        "plugins"
        "lsp"
        "servers"
      ];
      renameModules = lib.mapAttrsToList (
        old: new: lib.mkRenamedOptionModule (baseLspPath ++ [ old ]) (baseLspPath ++ [ new ])
      ) renamedServers;
      unsupportedModules = map (
        name:
        lib.mkRemovedOptionModule [ "plugins" "lsp" "servers" name ] ''
          nvim-lspconfig has switched from its own LSP configuration API to neovim's built-in LSP API.
          '${name}' has not been updated to support neovim's built-in LSP API.
          See https://github.com/neovim/nvim-lspconfig/issues/3705
        ''
      ) unsupportedServers;
    in
    lspModules
    ++ renameModules
    ++ unsupportedModules
    ++ [
      ./ccls.nix
      ./hls.nix
      ./pylsp.nix
      ./rust-analyzer.nix
      ./svelte.nix
    ];
}
