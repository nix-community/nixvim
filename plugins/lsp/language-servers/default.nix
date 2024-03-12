{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  lspHelpers = import ../helpers.nix {inherit lib config pkgs;};

  servers = [
    {
      name = "ansiblels";
      description = "ansiblels for Ansible";
      package = pkgs.ansible-language-server;
      cmd = cfg: ["${cfg.package}/bin/ansible-language-server" "--stdio"];
    }
    {
      name = "astro";
      description = "astrols for Astro";
      package = pkgs.nodePackages."@astrojs/language-server";
      cmd = cfg: ["${cfg.package}/bin/astro-ls" "--stdio"];
    }
    {
      name = "bashls";
      description = "bashls for bash";
      package = pkgs.nodePackages.bash-language-server;
    }
    {
      name = "beancount";
      description = "beancount-language-server";
      package = pkgs.beancount-language-server;
    }
    {
      name = "biome";
      description = "Biome, Toolchain of the Web";
    }
    {
      name = "ccls";
      description = "ccls for C/C++";
    }
    {
      name = "clangd";
      description = "clangd LSP for C/C++";
      package = pkgs.clang-tools;
    }
    {
      name = "clojure-lsp";
      description = "clojure-lsp for Clojure";
      serverName = "clojure_lsp";
      package = pkgs.clojure-lsp;
    }
    {
      name = "cmake";
      description = "cmake language server";
      package = pkgs.cmake-language-server;
    }
    {
      name = "csharp-ls";
      description = "csharp-ls for C#";
      package = pkgs.csharp-ls;
      serverName = "csharp_ls";
    }
    {
      name = "cssls";
      description = "cssls for CSS";
      package = pkgs.vscode-langservers-extracted;
      cmd = cfg: ["${cfg.package}/bin/vscode-css-language-server" "--stdio"];
    }
    {
      name = "dagger";
      description = "dagger for Cuelang";
      package = pkgs.cuelsp;
    }
    {
      name = "dartls";
      description = "dart language-server";
      package = pkgs.dart;
      settingsOptions = {
        analysisExcludedFolders = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = ''
            An array of paths (absolute or relative to each workspace folder) that should be
            excluded from analysis.
          '';
        };
        enableSdkFormatter = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = ''
            When set to false, prevents registration (or unregisters) the SDK formatter. When set
            to true or not supplied, will register/reregister the SDK formatter
          '';
        };
        lineLength = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            The number of characters the formatter should wrap code at. If unspecified, code will
            be wrapped at 80 characters.
          '';
        };
        completeFunctionCalls = mkOption {
          type = types.nullOr types.bool;
          default = true;
          description = ''
            When set to true, completes functions/methods with their required parameters.
          '';
        };
        showTodos = mkOption {
          type = types.nullOr types.bool;
          default = true;
          description = ''
            Whether to generate diagnostics for TODO comments. If unspecified, diagnostics will not
            be generated.
          '';
        };
        renameFilesWithClasses = mkOption {
          type = types.nullOr (types.enum ["always" "prompt"]);
          default = null;
          description = ''
            When set to "always", will include edits to rename files when classes are renamed if the
            filename matches the class name (but in snake_form). When set to "prompt", a prompt will
            be shown on each class rename asking to confirm the file rename. Otherwise, files will
            not be renamed. Renames are performed using LSP's ResourceOperation edits - that means
            the rename is simply included in the resulting WorkspaceEdit and must be handled by the
            client.
          '';
        };
        enableSnippets = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = ''
            Whether to include code snippets (such as class, stful, switch) in code completion. When
            unspecified, snippets will be included.
          '';
        };
        updateImportsOnRename = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = ''
            Whether to update imports and other directives when files are renamed. When unspecified,
            imports will be updated if the client supports willRenameFiles requests
          '';
        };
        documentation = mkOption {
          type = types.nullOr (types.enum ["none" "summary" "full"]);
          default = null;
          description = ''
            The typekind of dartdocs to include in Hovers, Code Completion, Signature Help and other
            similar requests. If not set, defaults to full
          '';
        };
        includeDependenciesInWorkspaceSymbols = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = ''
            Whether to include symbols from dependencies and Dart/Flutter SDKs in Workspace Symbol
            results. If not set, defaults to true.
          '';
        };
      };
      settings = cfg: {dart = cfg;};
    }
    {
      name = "denols";
      description = "denols for Deno";
      package = pkgs.deno;
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
      package = pkgs.lua54Packages.digestif;
    }
    {
      name = "dockerls";
      description = "dockerls for Dockerfile";
      package = pkgs.dockerfile-language-server-nodejs;
      cmd = cfg: ["${cfg.package}/bin/docker-langserver" "--stdio"];
    }
    {
      name = "efm";
      description = "efm-langserver for misc tools";
      package = pkgs.efm-langserver;
    }
    {
      name = "elmls";
      description = "elmls for Elm";
      package = pkgs.elmPackages.elm-language-server;
    }
    {
      name = "emmet_ls";
      description = "emmet_ls, emmet support based on LSP";
      package = pkgs.emmet-ls;
    }
    {
      name = "eslint";
      package = pkgs.vscode-langservers-extracted;
      cmd = cfg: ["${cfg.package}/bin/vscode-eslint-language-server" "--stdio"];
    }
    {
      name = "elixirls";
      package = pkgs.elixir-ls;
      cmd = cfg: ["${cfg.package}/bin/elixir-ls"];
    }
    {
      name = "fortls";
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
      package = pkgs.fsautocomplete;
    }
    {
      name = "futhark-lsp";
      description = "futhark-lsp for Futhark";
      package = pkgs.futhark;
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
    }
    {
      name = "graphql";
      description = "graphql for GraphQL";
      package = pkgs.nodePackages.graphql-language-service-cli;
    }
    {
      name = "helm-ls";
      description = "helm_ls for Helm";
      serverName = "helm_ls";
    }
    {
      name = "hls";
      description = "haskell language server";
      package = pkgs.haskell-language-server;
      cmd = cfg: ["haskell-language-server-wrapper" "--lsp"];
    }
    {
      name = "html";
      description = "HTML language server from `vscode-langservers-extracted`";
      package = pkgs.vscode-langservers-extracted;
      cmd = cfg: ["${cfg.package}/bin/vscode-html-language-server" "--stdio"];
    }
    {
      name = "htmx";
      description = "htmx for HTMX";
      package = pkgs.htmx-lsp;
    }
    {
      name = "intelephense";
      description = "intelephense for PHP";
      package = pkgs.nodePackages.intelephense;
    }
    {
      name = "java-language-server";
      description = "Java language server";
      serverName = "java_language_server";
      cmd = cfg: ["${cfg.package}/bin/java-language-server"];
    }
    {
      name = "jsonls";
      description = "jsonls for JSON";
      package = pkgs.vscode-langservers-extracted;
      cmd = cfg: ["${cfg.package}/bin/vscode-json-language-server" "--stdio"];
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
      package = pkgs.lean4;
    }
    {
      name = "lemminx";
      description = "lemminx for XML";
    }
    {
      name = "ltex";
      description = "ltex-ls for LanguageTool";
      package = pkgs.ltex-ls;
      settingsOptions = import ./ltex-settings.nix {inherit lib helpers;};
      settings = cfg: {ltex = cfg;};
    }
    {
      name = "lua-ls";
      description = "lua-ls for Lua";
      # Use the old name of the lua LS if the user is on a stable branch of nixpkgs
      # Rename occurred here: https://github.com/NixOS/nixpkgs/pull/215057
      package =
        if (hasAttr "lua-language-server" pkgs)
        then pkgs.lua-language-server
        else pkgs.sumneko-lua-language-server;
      serverName = "lua_ls";

      # All available settings are documented here:
      # https://github.com/LuaLS/lua-language-server/wiki/Settings
      settingsOptions = {
        runtime = {
          version = mkOption {
            type = types.nullOr types.str;
            description = ''
              Tell the language server which version of Lua you're using
              (most likely LuaJIT in the case of Neovim)
            '';
            default = "LuaJIT";
          };
        };
        diagnostics = {
          globals = mkOption {
            type = types.nullOr (types.listOf types.str);
            description = ''
              An array of variable names that will be declared as global.
            '';
            default = ["vim"];
          };
        };
        workspace = {
          library = mkOption {
            type = with types;
              nullOr
              (
                listOf
                (either str helpers.nixvimTypes.rawLua)
              );
            description = ''
              An array of abosolute or workspace-relative paths that will be added to the workspace
              diagnosis - meaning you will get completion and context from these library files.
              Can be a file or directory.
              Files included here will have some features disabled such as renaming fields to
              prevent accidentally renaming your library files.
            '';
            default = [(helpers.mkRaw "vim.api.nvim_get_runtime_file('', true)")];
          };
          checkThirdParty = mkOption {
            type = types.nullOr types.bool;
            description = ''
              Whether third party libraries can be automatically detected and applied.
              Third party libraries can set up the environment to be as close as possible to your
              target runtime environment.
            '';
            # prevents an annoying warning
            # https://github.com/LuaLS/lua-language-server/discussions/1688#discussioncomment-4185003
            default = false;
          };
        };
        telemetry = {
          enable = mkEnableOption "telemetry";
        };
      };
      settings = cfg: {Lua = cfg;};
    }
    {
      name = "marksman";
      description = "marksman for Markdown";
      package = pkgs.marksman;
    }
    {
      name = "metals";
      description = "metals for Scala";
    }
    {
      name = "nil_ls";
      description = "nil for Nix";
      package = pkgs.nil;
      settingsOptions = {
        formatting.command = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = ''
            External formatter command (with arguments).
            It should accepts file content in stdin and print the formatted code into stdout.
          '';
        };
        diagnostics = {
          ignored = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              Ignored diagnostic kinds.
              The kind identifier is a snake_cased_string usually shown together
              with the diagnostic message.
            '';
          };
          excludedFiles = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              Files to exclude from showing diagnostics. Useful for generated files.
              It accepts an array of paths. Relative paths are joint to the workspace root.
              Glob patterns are currently not supported.
            '';
          };
        };
      };
      settings = cfg: {nil = {inherit (cfg) formatting diagnostics;};};
    }
    {
      name = "nixd";
      description = "nixd for Nix";
      package = pkgs.nixd;
      settings = cfg: {nixd = cfg;};
    }
    {
      name = "nushell";
      description = "Nushell language server";
      cmd = cfg: ["${cfg.package}/bin/nu" "--lsp"];
    }
    {
      name = "ocamllsp";
      description = "ocamllsp for OCaml";
      package = pkgs.ocamlPackages.ocaml-lsp;
    }
    {
      name = "ols";
      description = "ols for the Odin programming language";
      package = pkgs.ols;
    }
    {
      name = "omnisharp";
      description = "OmniSharp language server for C#";
      package = pkgs.omnisharp-roslyn;
      cmd = cfg: ["${cfg.package}/bin/OmniSharp"];
      settings = cfg: {omnisharp = cfg;};
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
      name = "perlpls";
      description = "PLS for Perl";
      package = pkgs.perlPackages.PLS;
    }
    {
      name = "pest_ls";
      description = "pest_ls for pest";
      package = pkgs.pest-ide-tools;
    }
    {
      name = "phpactor";
      description = "phpactor for PHP";
      package = pkgs.phpactor;
    }
    {
      name = "prismals";
      description = "prismals for Prisma";
      package = pkgs.nodePackages."@prisma/language-server";
    }
    {
      name = "prolog-ls";
      description = "prolog_ls for SWI-Prolog";
      serverName = "prolog_ls";
      package = pkgs.swiProlog;
    }
    {
      name = "purescriptls";
      description = "purescriptls for PureScript";
      package = pkgs.nodePackages.purescript-language-server;
    }
    {
      name = "pylsp";
      description = "pylsp for Python";
      package = pkgs.python3Packages.python-lsp-server;
      settings = cfg: {pylsp = cfg;};
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
      name = "rnix-lsp";
      description = "rnix LSP for Nix";
      serverName = "rnix";
      package = null;
    }
    {
      name = "ruff-lsp";
      description = "ruff-lsp, for Python";
      package = pkgs.python3Packages.ruff-lsp;
      serverName = "ruff_lsp";
    }
    {
      name = "rust-analyzer";
      description = "rust-analyzer for Rust";
      serverName = "rust_analyzer";

      settingsOptions = import ./rust-analyzer-config.nix lib pkgs;
      settings = cfg: {rust-analyzer = cfg;};
    }
    {
      name = "slint-lsp";
      description = "slint_lsp for Slint GUI language";
      serverName = "slint_lsp";
    }
    {
      name = "solargraph";
      description = "solargraph for Ruby";
      package = pkgs.rubyPackages.solargraph;
    }
    {
      name = "sourcekit";
      description = "sourcekit language server for Swift and C/C++/Objective-C";
      package = pkgs.sourcekit-lsp;
    }
    {
      name = "svelte";
      description = "svelte language server for Svelte";
      package = pkgs.nodePackages.svelte-language-server;
    }
    {
      name = "tailwindcss";
      description = "tailwindcss language server for tailwindcss";
      package = pkgs.nodePackages."@tailwindcss/language-server";
    }
    {
      name = "taplo";
      description = "taplo for TOML";
      package = pkgs.taplo;
    }
    {
      name = "templ";
      description = "templ language server for the templ HTML templating language";
    }
    {
      name = "terraformls";
      description = "terraform-ls for terraform";
      package = pkgs.terraform-ls;
    }
    {
      name = "texlab";
      description = "texlab language server for LaTeX";
    }
    {
      name = "tsserver";
      description = "tsserver for TypeScript";
      package = pkgs.nodePackages.typescript-language-server;
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
      package = pkgs.typst-lsp;
    }
    {
      name = "vala-ls";
      description = "vala_ls for Vala";
      serverName = "vala_ls";
      package = pkgs.vala-language-server;
    }
    {
      name = "vls";
      description = "vls for V";
      # The v language server has to be installed from v and thus is not packaged "as is" in
      # nixpkgs.
      package = null;
    }
    {
      name = "vuels";
      description = "vuels for Vue";
      package = pkgs.nodePackages.vls;
    }
    {
      name = "volar";
      description = "@volar/vue-language-server for Vue";
      package = pkgs.nodePackages."@volar/vue-language-server";
    }
    {
      name = "yamlls";
      description = "yamlls for YAML";
      package = pkgs.yaml-language-server;
    }
    {
      name = "zls";
      description = "zls for Zig";
    }
  ];
in {
  imports =
    lib.lists.map lspHelpers.mkLsp servers
    ++ [
      ./ccls.nix
      ./efmls-configs.nix
      ./nixd.nix
      ./pylsp.nix
      ./rust-analyzer.nix
      ./svelte.nix
      ./vls.nix
    ];
}
