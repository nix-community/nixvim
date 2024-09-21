{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
let
  servers = [
    {
      name = "ansiblels";
      description = "ansiblels for Ansible";
      package = "ansible-language-server";
      cmd = cfg: [
        "${cfg.package}/bin/ansible-language-server"
        "--stdio"
      ];
    }
    {
      name = "ast-grep";
      description = ''
        ast-grep(sg) is a fast and polyglot tool for code structural search, lint, rewriting at large scale.
        ast-grep LSP only works in projects that have `sgconfig.y[a]ml` in their root directories.
      '';
      serverName = "ast_grep";
    }
    {
      name = "astro";
      description = "astrols for Astro";
      package = "astro-language-server";
      cmd = cfg: [
        "${cfg.package}/bin/astro-ls"
        "--stdio"
      ];
    }
    {
      name = "basedpyright";
      description = "basedpyright, a static type checker and language server for python";
    }
    {
      name = "bashls";
      description = "bashls for bash";
      package = "bash-language-server";
    }
    {
      name = "beancount";
      description = "beancount-language-server";
      package = "beancount-language-server";
    }
    {
      name = "biome";
      description = "Biome, Toolchain of the Web";
    }
    {
      name = "bufls";
      description = "Prototype for a Protobuf language server compatible with Buf.";
      package = "buf-language-server";
    }
    {
      name = "ccls";
      description = "ccls for C/C++";
    }
    {
      name = "clangd";
      description = "clangd LSP for C/C++";
      package = "clang-tools";
    }
    {
      name = "clojure-lsp";
      description = "clojure-lsp for Clojure";
      serverName = "clojure_lsp";
    }
    {
      name = "cmake";
      description = "cmake language server";
      package = "cmake-language-server";
    }
    {
      name = "csharp-ls";
      description = "csharp-ls for C#";
      serverName = "csharp_ls";
    }
    {
      name = "cssls";
      description = "cssls for CSS";
      package = "vscode-langservers-extracted";
      cmd = cfg: [
        "${cfg.package}/bin/vscode-css-language-server"
        "--stdio"
      ];
    }
    {
      name = "dagger";
      description = "dagger for Cuelang";
      package = "cuelsp";
    }
    {
      name = "dartls";
      description = "dart language-server";
      package = "dart";
      settingsOptions = import ./dartls-settings.nix { inherit lib helpers; };
      settings = cfg: { dart = cfg; };
    }
    {
      name = "denols";
      description = "denols for Deno";
      package = "deno";
    }
    {
      name = "dhall-lsp-server";
      description = "dhall-lsp-server for Dhall";
      serverName = "dhall_lsp_server";
    }
    {
      name = "digestif";
      description = "digestif for LaTeX";
      # luaPackages.digestif is currently broken, using lua54Packages instead
      package = [
        "lua54Packages"
        "digestif"
      ];
    }
    {
      name = "docker-compose-language-service";
      description = "docker-compose-language-service for Docker Compose";
      serverName = "docker_compose_language_service";
    }
    {
      name = "dockerls";
      description = "dockerls for Dockerfile";
      package = "dockerfile-language-server-nodejs";
      cmd = cfg: [
        "${cfg.package}/bin/docker-langserver"
        "--stdio"
      ];
    }
    {
      name = "efm";
      description = "efm-langserver for misc tools";
      package = "efm-langserver";
    }
    {
      name = "elmls";
      description = "elmls for Elm";
      package = [
        "elmPackages"
        "elm-language-server"
      ];
    }
    {
      name = "emmet-ls";
      description = "emmet_ls, emmet support based on LSP";
      serverName = "emmet_ls";
    }
    {
      name = "eslint";
      package = "vscode-langservers-extracted";
      cmd = cfg: [
        "${cfg.package}/bin/vscode-eslint-language-server"
        "--stdio"
      ];
    }
    {
      name = "elixirls";
      package = "elixir-ls";
      cmd = cfg: [ "${cfg.package}/bin/elixir-ls" ];
    }
    {
      name = "fortls";
      description = "fortls for Fortran";
      cmd = cfg: [
        "${cfg.package}/bin/fortls"
        "--hover_signature"
        "--hover_language=fortran"
        "--use_signature_help"
      ];
    }
    {
      name = "fsautocomplete";
      description = "fsautocomplete for F#";
    }
    {
      name = "futhark-lsp";
      description = "futhark-lsp for Futhark";
      package = "futhark";
      serverName = "futhark_lsp";
    }
    {
      name = "gdscript";
      description = "gdscript for Godot";
      package = null;
    }
    {
      name = "gleam";
      description = "gleam for gleam";
    }
    {
      name = "gopls";
      description = "gopls for Go";
      extraOptions = {
        goPackage = lib.mkPackageOption pkgs "go" {
          nullable = true;
        };
      };
      extraConfig = cfg: {
        extraPackages = [ cfg.goPackage ];
      };
    }
    {
      name = "golangci-lint-ls";
      description = "golangci-lint-ls for Go";
      serverName = "golangci_lint_ls";
      package = "golangci-lint-langserver";
    }
    {
      name = "graphql";
      description = "graphql for GraphQL";
      package = [
        "nodePackages"
        "graphql-language-service-cli"
      ];
    }
    {
      name = "harper-ls";
      description = "The Grammar Checker for Developers";
      serverName = "harper_ls";
      package = "harper";
    }
    {
      name = "helm-ls";
      description = "helm_ls for Helm";
      serverName = "helm_ls";
    }
    {
      name = "hls";
      description = "haskell language server";
      package = "haskell-language-server";
      cmd = cfg: [
        "haskell-language-server-wrapper"
        "--lsp"
      ];
    }
    {
      name = "html";
      description = "HTML language server from `vscode-langservers-extracted`";
      package = "vscode-langservers-extracted";
      cmd = cfg: [
        "${cfg.package}/bin/vscode-html-language-server"
        "--stdio"
      ];
    }
    {
      name = "htmx";
      description = "htmx for HTMX";
      package = "htmx-lsp";
    }
    {
      name = "idris2-lsp";
      description = "Idris 2 Language Server";
      serverName = "idris2_lsp";
      package = [
        "idris2Packages"
        "idris2Lsp"
      ];
    }
    {
      name = "intelephense";
      description = "intelephense for PHP";
      package = [
        "nodePackages"
        "intelephense"
      ];
    }
    {
      name = "java-language-server";
      description = "Java language server";
      serverName = "java_language_server";
      cmd = cfg: [ "${cfg.package}/bin/java-language-server" ];
    }
    {
      name = "jdt-language-server";
      description = "Eclipse JDT Language Server for Java";
      serverName = "jdtls";
      cmd = cfg: [ (lib.getExe cfg.package) ];
    }
    {
      name = "jsonls";
      description = "jsonls for JSON";
      package = "vscode-langservers-extracted";
      cmd = cfg: [
        "${cfg.package}/bin/vscode-json-language-server"
        "--stdio"
      ];
      settings = cfg: { json = cfg; };
    }
    {
      name = "jsonnet-ls";
      description = "jsonnet language server";
      package = "jsonnet-language-server";
      serverName = "jsonnet_ls";
      settingsOptions = import ./jsonnet-ls-settings.nix { inherit lib helpers; };
    }
    {
      name = "julials";
      description = "julials for Julia";
      # The julia language server has to be installed from julia and thus is not packaged "as is" in
      # nixpkgs.
      package = null;
    }
    {
      name = "kotlin-language-server";
      description = "Kotlin language server";
      serverName = "kotlin_language_server";
    }
    {
      name = "leanls";
      description = "leanls for Lean";
      package = "lean4";
    }
    {
      name = "lemminx";
      description = "lemminx for XML";
    }
    {
      name = "lexical";
      description = "lexical for Elixir";
    }
    {
      name = "ltex";
      description = "ltex-ls for LanguageTool";
      package = "ltex-ls";
      settingsOptions = import ./ltex-settings.nix { inherit lib helpers; };
      settings = cfg: { ltex = cfg; };
    }
    {
      name = "lua-ls";
      description = "lua-ls for Lua";
      package = "lua-language-server";
      serverName = "lua_ls";
      settingsOptions = import ./lua-ls-settings.nix { inherit lib helpers; };
      settings = cfg: { Lua = cfg; };
    }
    {
      name = "marksman";
      description = "marksman for Markdown";
    }
    {
      name = "metals";
      description = "metals for Scala";
    }
    {
      name = "nextls";
      description = "The language server for Elixir that just works.";
      package = "next-ls";
      cmd = cfg: [
        "nextls"
        "--stdio"
      ];
    }
    {
      name = "nginx-language-server";
      description = "nginx-language-server for `nginx.conf`";
      serverName = "nginx_language_server";
    }
    {
      name = "nickel-ls";
      description = "nls for Nickel";
      package = "nls";
      serverName = "nickel_ls";
    }
    {
      name = "nil-ls";
      description = "nil for Nix";
      package = "nil";
      serverName = "nil_ls";
      settingsOptions = import ./nil-ls-settings.nix { inherit lib helpers; };
      settings = cfg: { nil = cfg; };
    }
    {
      name = "nimls";
      description = "nimls for Nim";
      package = "nimlsp";
    }
    {
      name = "nixd";
      description = "nixd for Nix";
      settings = cfg: { nixd = cfg; };
      settingsOptions = import ./nixd-settings.nix { inherit lib helpers; };
      extraConfig = cfg: {
        extraPackages = optional (cfg.settings.formatting.command == [ "nixpkgs-fmt" ]) pkgs.nixpkgs-fmt;
      };
    }
    {
      name = "nushell";
      description = "Nushell language server";
      cmd = cfg: [
        "${cfg.package}/bin/nu"
        "--lsp"
      ];
    }
    {
      name = "ocamllsp";
      description = "ocamllsp for OCaml";
      package = [
        "ocamlPackages"
        "ocaml-lsp"
      ];
    }
    {
      name = "ols";
      description = "ols for the Odin programming language";
    }
    {
      name = "omnisharp";
      description = "OmniSharp language server for C#";
      package = "omnisharp-roslyn";
      cmd = cfg: [ "${cfg.package}/bin/OmniSharp" ];
      settings = cfg: { omnisharp = cfg; };
      settingsOptions = {
        enableEditorConfigSupport = helpers.defaultNullOpts.mkBool true ''
          Enables support for reading code style, naming convention and analyzer settings from
          `.editorconfig`.
        '';

        enableMsBuildLoadProjectsOnDemand = helpers.defaultNullOpts.mkBool false ''
          If true, MSBuild project system will only load projects for files that were opened in the
          editor.
          This setting is useful for big C# codebases and allows for faster initialization of code
          navigation features only for projects that are relevant to code that is being edited.
          With this setting enabled OmniSharp may load fewer projects and may thus display
          incomplete reference lists for symbols.
        '';

        enableRoslynAnalyzers = helpers.defaultNullOpts.mkBool false ''
          If true, MSBuild project system will only load projects for files that were opened in the
          editor.
          This setting is useful for big C# codebases and allows for faster initialization of code
          navigation features only for projects that are relevant to code that is being edited.
          With this setting enabled OmniSharp may load fewer projects and may thus display
          incomplete reference lists for symbols.
        '';

        organizeImportsOnFormat = helpers.defaultNullOpts.mkBool false ''
          Specifies whether 'using' directives should be grouped and sorted during document
          formatting.
        '';

        enableImportCompletion = helpers.defaultNullOpts.mkBool false ''
          Enables support for showing unimported types and unimported extension methods in
          completion lists.
          When committed, the appropriate using directive will be added at the top of the current
          file.
          This option can have a negative impact on initial completion responsiveness, particularly
          for the first few completion sessions after opening a solution.
        '';

        sdkIncludePrereleases = helpers.defaultNullOpts.mkBool true ''
          Specifies whether to include preview versions of the .NET SDK when determining which
          version to use for project loading.
        '';

        analyzeOpenDocumentsOnly = helpers.defaultNullOpts.mkBool true ''
          Only run analyzers against open files when 'enableRoslynAnalyzers' is true.
        '';
      };
    }
    {
      name = "openscad-lsp";
      description = "A Language Server Protocol server for OpenSCAD";
      serverName = "openscad_lsp";
    }
    {
      name = "perlpls";
      description = "PLS for Perl";
      package = [
        "perlPackages"
        "PLS"
      ];
    }
    {
      name = "pest-ls";
      description = "pest_ls for pest";
      package = "pest-ide-tools";
      serverName = "pest_ls";
    }
    {
      name = "phpactor";
      description = "phpactor for PHP";
      package = "phpactor";
    }
    {
      name = "prismals";
      description = "prismals for Prisma";
      package = [
        "nodePackages"
        "@prisma/language-server"
      ];
    }
    {
      name = "prolog-ls";
      description = "prolog_ls for SWI-Prolog";
      serverName = "prolog_ls";
      package = "swiProlog";
    }
    {
      name = "purescriptls";
      description = "purescriptls for PureScript";
      package = [
        "nodePackages"
        "purescript-language-server"
      ];
    }
    {
      name = "pylsp";
      description = "pylsp for Python";
      package = [
        "python3Packages"
        "python-lsp-server"
      ];
      settings = cfg: { pylsp = cfg; };
    }
    {
      name = "pylyzer";
      description = "pylyzer for Python";
    }
    {
      name = "pyright";
      description = "pyright for Python";
    }
    {
      name = "r-language-server";
      description = "languageserver for R";
      package = [
        "rPackages"
        "languageserver"
      ];
      serverName = "r_language_server";
    }
    {
      name = "rnix-lsp";
      description = "rnix LSP for Nix";
      serverName = "rnix";
      package = null;
    }
    {
      name = "ruby-lsp";
      description = "ruby-lsp for Ruby";
      serverName = "ruby_lsp";
    }
    {
      name = "ruff";
      description = "Official ruff language server (Rust) for Python";
    }
    {
      name = "ruff-lsp";
      description = "ruff-lsp, for Python";
      serverName = "ruff_lsp";
    }
    {
      name = "rust-analyzer";
      description = "rust-analyzer for Rust";
      serverName = "rust_analyzer";

      settingsOptions = import ./rust-analyzer-config.nix lib helpers;
      settings = cfg: { rust-analyzer = cfg; };
    }
    {
      name = "slint-lsp";
      description = "slint_lsp for Slint GUI language";
      serverName = "slint_lsp";
    }
    {
      name = "solargraph";
      description = "solargraph for Ruby";
      package = [
        "rubyPackages"
        "solargraph"
      ];
    }
    {
      name = "sourcekit";
      description = "sourcekit language server for Swift and C/C++/Objective-C";
      package = "sourcekit-lsp";
    }
    {
      name = "sqls";
      description = "sqls for SQL";
    }
    {
      name = "svelte";
      description = "svelte language server for Svelte";
      package = [
        "nodePackages"
        "svelte-language-server"
      ];
    }
    {
      name = "tailwindcss";
      description = "tailwindcss language server for tailwindcss";
      package = [
        "nodePackages"
        "@tailwindcss/language-server"
      ];
    }
    {
      name = "taplo";
      description = "taplo for TOML";
    }
    {
      name = "templ";
      description = "templ language server for the templ HTML templating language";
    }
    {
      name = "terraformls";
      description = "terraform-ls for terraform";
      package = "terraform-ls";
    }
    {
      name = "texlab";
      description = "texlab language server for LaTeX";
    }
    {
      name = "tflint";
      description = "tflint, a terraform linter";
    }
    {
      name = "tinymist";
      description = "tinymist for Typst";
      settingsOptions = import ./tinymist-settings.nix { inherit lib helpers; };
    }
    {
      name = "ts-ls";
      serverName = "ts_ls";
      description = "ts_ls for TypeScript";
      package = "typescript-language-server";
      # NOTE: Provide the plugin default filetypes so that
      # `plugins.lsp.servers.volar.tslsIntegration` doesn't wipe out the default filetypes
      extraConfig = cfg: {
        plugins.lsp.servers.ts-ls = {
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
    }
    {
      name = "typos-lsp";
      serverName = "typos_lsp";
      description = "Source code spell checker for Visual Studio Code and LSP clients";
    }
    {
      name = "typst-lsp";
      serverName = "typst_lsp";
      description = "typst-lsp for typst";
    }
    {
      name = "vala-ls";
      description = "vala_ls for Vala";
      serverName = "vala_ls";
      package = "vala-language-server";
    }
    {
      name = "vhdl-ls";
      description = "vhdl_ls for VHDL";
      serverName = "vhdl_ls";
    }
    {
      name = "vls";
      description = "vls for V";
      # The v language server has to be installed from v and thus is not packaged "as is" in
      # nixpkgs.
      package = null;
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
        filetype.extension = mkIf (cfg.enable && cfg.autoSetFiletype) { v = "vlang"; };
      };
    }
    {
      name = "vuels";
      description = "vuels for Vue";
      package = [
        "nodePackages"
        "vls"
      ];
    }
    {
      name = "volar";
      description = "@volar/vue-language-server for Vue";
      package = [
        "nodePackages"
        "@volar/vue-language-server"
      ];
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
      extraConfig = cfg: {
        plugins.lsp.servers.ts-ls = lib.mkIf (cfg.enable && cfg.tslsIntegration) {
          filetypes = [ "vue" ];
          extraOptions = {
            init_options = {
              plugins = [
                {
                  name = "@vue/typescript-plugin";
                  location = "${lib.getBin cfg.package}/lib/node_modules/@vue/language-server";
                  languages = [ "vue" ];
                }
              ];
            };
          };
        };
      };
    }
    {
      name = "yamlls";
      description = "yamlls for YAML";
      package = "yaml-language-server";
      settings = cfg: { yaml = cfg; };
    }
    {
      name = "zls";
      description = "zls for Zig";
    }
  ];
  renamedServers = {
    tsserver = "ts-ls";
  };
in
{
  imports =
    let
      mkLsp = import ./_mk-lsp.nix;
      lspModules = map mkLsp servers;
      baseLspPath = [
        "plugins"
        "lsp"
        "servers"
      ];
      renameModules = mapAttrsToList (
        old: new: lib.mkRenamedOptionModule (baseLspPath ++ [ old ]) (baseLspPath ++ [ new ])
      ) renamedServers;
    in
    lspModules
    ++ renameModules
    ++ [
      ./ccls.nix
      ./efmls-configs.nix
      ./pylsp.nix
      ./rust-analyzer.nix
      ./svelte.nix
    ];
}
