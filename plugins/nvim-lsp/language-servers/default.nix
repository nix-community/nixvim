{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  lspHelpers = import ../helpers.nix args;
  helpers = import ../../helpers.nix {inherit lib;};

  optionWarnings = import ../../../lib/option-warnings.nix args;
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
      name = "hls";
      description = "Enable haskell language server";
      package = pkgs.haskell-language-server;
      cmd = cfg: ["haskell-language-server-wrapper"];
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
      name = "lua-ls";
      description = "Enable lua LS, for lua";
      # Use the old name of the lua LS if the user is on a stable branch of nixpkgs
      # Rename occured here: https://github.com/NixOS/nixpkgs/pull/215057
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
            type = types.nullOr (types.either types.str (helpers.rawType));
            description = ''
              An array of abosolute or workspace-relative paths that will be added to the workspace
              diagnosis - meaning you will get completion and context from these library files.
              Can be a file or directory.
              Files included here will have some features disabled such as renaming fields to
              prevent accidentally renaming your library files.
            '';
            default = helpers.mkRaw "vim.api.nvim_get_runtime_file('', true)";
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
      name = "metals";
      description = "Enable metals, for Scala";
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
      name = "pylsp";
      description = "Enable pylsp, for Python.";
      package = pkgs.python3Packages.python-lsp-server;
      settings = cfg: {pylsp = cfg;};
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
      name = "tailwindcss";
      description = "Enable tailwindcss language server, for tailwindcss";
      package = pkgs.nodePackages."@tailwindcss/language-server";
    }
    {
      name = "terraformls";
      description = "Enable terraform-ls, for terraform";
      package = pkgs.terraform-ls;
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
      name = "typst-lsp";
      serverName = "typst_lsp";
      description = "Enable typst-lsp for typst";
      package = pkgs.typst-lsp;
    }
    {
      name = "vuels";
      description = "Enable vuels, for Vue";
      package = pkgs.nodePackages.vls;
    }
    {
      name = "yamlls";
      description = "Enable yamlls, for yaml";
      package = pkgs.yaml-language-server;
    }
    {
      name = "zls";
      description = "Enable zls, for Zig.";
    }
  ];
in {
  imports =
    lib.lists.map (lspHelpers.mkLsp) servers
    ++ [./pylsp.nix]
    ++ [
      (optionWarnings.mkRenamedOption {
        option = basePluginPath ++ ["sumneko-lua"];
        newOption = basePluginPath ++ ["lua-ls"];
      })
    ];
}
