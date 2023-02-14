{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  helpers = import ./helpers.nix args;

  optionWarnings = import ../../lib/option-warnings.nix args;
  basePluginPath = ["plugins" "lsp" "servers"];

  servers = [
    {
      name = "astro";
      description = "Enable astrols, for Astro";
      package = pkgs.nodePackages."@astrojs/language-server";
      cmd = cfg: ["${cfg.package}/bin/astro-ls" "--stdio"];
    }
    {
      name = "bashls";
      description = "Enable bashls, for bash.";
      package = pkgs.nodePackages.bash-language-server;
    }
    {
      name = "clangd";
      description = "Enable clangd LSP, for C/C++.";
      package = pkgs.clang-tools;
    }
    {
      name = "cssls";
      description = "Enable cssls, for CSS";
      package = pkgs.nodePackages.vscode-langservers-extracted;
      cmd = cfg: ["${cfg.package}/bin/vscode-css-language-server" "--stdio"];
    }
    {
      name = "dartls";
      description = "Enable dart language-server, for dart";
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
      description = "Enable denols, for Deno";
      package = pkgs.deno;
    }
    {
      name = "eslint";
      description = "Enable eslint";
      package = pkgs.nodePackages.vscode-langservers-extracted;
      cmd = cfg: ["${cfg.package}/bin/vscode-eslint-language-server" "--stdio"];
    }
    {
      name = "elixirls";
      description = "Enable elixirls";
      package = pkgs.elixir_ls;
      cmd = cfg: ["${cfg.package}/bin/elixir-ls"];
    }
    {
      name = "gdscript";
      description = "Enable gdscript, for Godot";
      package = null;
    }
    {
      name = "gopls";
      description = "Enable gopls, for Go.";
    }
    {
      name = "html";
      description = "Enable html, for HTML";
      package = pkgs.nodePackages.vscode-langservers-extracted;
      cmd = cfg: ["${cfg.package}/bin/vscode-html-language-server" "--stdio"];
    }
    {
      name = "jsonls";
      description = "Enable jsonls, for JSON";
      package = pkgs.nodePackages.vscode-langservers-extracted;
      cmd = cfg: ["${cfg.package}/bin/vscode-json-language-server" "--stdio"];
    }
    {
      name = "nil_ls";
      description = "Enable nil, for Nix";
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
      name = "pyright";
      description = "Enable pyright, for Python.";
    }
    {
      name = "rnix-lsp";
      description = "Enable rnix LSP, for Nix";
      serverName = "rnix";
    }
    {
      name = "rust-analyzer";
      description = "Enable rust-analyzer, for Rust.";
      serverName = "rust_analyzer";

      settingsOptions = import ./rust-analyzer-config.nix lib;
      settings = cfg: {rust-analyzer = cfg;};
    }
    {
      name = "lua-ls";
      description = "Enable lua LS, for lua";
      package = pkgs.lua-language-server;
      serverName = "lua_ls";
    }
    {
      name = "tailwindcss";
      description = "Enable tailwindcss language server, for tailwindcss";
      package = pkgs.nodePackages."@tailwindcss/language-server";
    }
    {
      name = "texlab";
      description = "Enable texlab language server, for LaTeX";
    }
    {
      name = "tsserver";
      description = "Enable tsserver for typescript";
      package = pkgs.nodePackages.typescript-language-server;
    }
    {
      name = "vuels";
      description = "Enable vuels, for Vue";
      package = pkgs.nodePackages.vue-language-server;
    }
    {
      name = "zls";
      description = "Enable zls, for Zig.";
    }
    {
      name = "hls";
      description = "Enable haskell language server";
      package = pkgs.haskell-language-server;
      cmd = cfg: ["haskell-language-server-wrapper"];
    }
  ];
in {
  imports =
    lib.lists.map (helpers.mkLsp) servers
    ++ [
      (optionWarnings.mkRenamedOption {
        option = basePluginPath ++ ["sumneko-lua"];
        newOption = basePluginPath ++ ["lua-ls"];
      })
    ];
}
