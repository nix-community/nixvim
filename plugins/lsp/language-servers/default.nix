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
    jsonnet_ls = {
      settingsOptions = import ./jsonnet-ls-settings.nix { inherit lib; };
    };
    ltex = {
      settingsOptions = import ./ltex-settings.nix { inherit lib; };
      settings = cfg: { ltex = cfg; };
    };
    lua_ls = {
      settingsOptions = import ./lua-ls-settings.nix { inherit lib; };
      settings = cfg: { Lua = cfg; };
    };
    nil_ls = {
      settingsOptions = import ./nil-ls-settings.nix { inherit lib; };
      settings = cfg: { nil = cfg; };
    };
    nixd = {
      settings = cfg: { nixd = cfg; };
      settingsOptions = import ./nixd-settings.nix { inherit lib; };
      extraConfig = cfg: {
        extraPackages = lib.optional (
          cfg.settings.formatting.command == [ "nixpkgs-fmt" ]
        ) pkgs.nixpkgs-fmt;
      };
    };
    omnisharp = {
      settings = cfg: { omnisharp = cfg; };
      settingsOptions = {
        enableEditorConfigSupport = lib.nixvim.defaultNullOpts.mkBool true ''
          Enables support for reading code style, naming convention and analyzer settings from
          `.editorconfig`.
        '';

        enableMsBuildLoadProjectsOnDemand = lib.nixvim.defaultNullOpts.mkBool false ''
          If true, MSBuild project system will only load projects for files that were opened in the
          editor.
          This setting is useful for big C# codebases and allows for faster initialization of code
          navigation features only for projects that are relevant to code that is being edited.
          With this setting enabled OmniSharp may load fewer projects and may thus display
          incomplete reference lists for symbols.
        '';

        enableRoslynAnalyzers = lib.nixvim.defaultNullOpts.mkBool false ''
          If true, MSBuild project system will only load projects for files that were opened in the
          editor.
          This setting is useful for big C# codebases and allows for faster initialization of code
          navigation features only for projects that are relevant to code that is being edited.
          With this setting enabled OmniSharp may load fewer projects and may thus display
          incomplete reference lists for symbols.
        '';

        organizeImportsOnFormat = lib.nixvim.defaultNullOpts.mkBool false ''
          Specifies whether 'using' directives should be grouped and sorted during document
          formatting.
        '';

        enableImportCompletion = lib.nixvim.defaultNullOpts.mkBool false ''
          Enables support for showing unimported types and unimported extension methods in
          completion lists.
          When committed, the appropriate using directive will be added at the top of the current
          file.
          This option can have a negative impact on initial completion responsiveness, particularly
          for the first few completion sessions after opening a solution.
        '';

        sdkIncludePrereleases = lib.nixvim.defaultNullOpts.mkBool true ''
          Specifies whether to include preview versions of the .NET SDK when determining which
          version to use for project loading.
        '';

        analyzeOpenDocumentsOnly = lib.nixvim.defaultNullOpts.mkBool true ''
          Only run analyzers against open files when 'enableRoslynAnalyzers' is true.
        '';
      };
    };
    pylsp = {
      settings = cfg: { pylsp = cfg; };
    };
    rust_analyzer = {
      settingsOptions = import ./rust-analyzer-config.nix lib;
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
