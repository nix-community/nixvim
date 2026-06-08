{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "typescript-tools";
  package = "typescript-tools-nvim";
  description = "A collection of tools for working with TypeScript and JavaScript in Neovim, including LSP support, code actions, and more.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    on_attach = defaultNullOpts.mkLuaFn null "Function to call when tsserver attaches to a buffer.";

    handlers = lib.mkOption {
      type = with lib.types; nullOr (attrsOf strLuaFn);
      default = null;
      description = "How tsserver should respond to LSP requests";
      example = {
        "textDocument/publishDiagnostics" = ''
          require("typescript-tools.api").filter_diagnostics(
            -- Ignore 'This may be converted to an async function' diagnostics.
            { 80006 }
          )
        '';
      };
    };

    settings = {
      separate_diagnostic_server = defaultNullOpts.mkBool true "Spawns an additional tsserver instance to calculate diagnostics";

      publish_diagnostic_on =
        defaultNullOpts.mkEnum
          [
            "change"
            "insert_leave"
          ]
          "insert_leave"
          ''
            Either "change" or "insert_leave". Determines when the client asks the server about diagnostics
          '';

      expose_as_code_action = lib.mkOption {
        type =
          with lib.types;
          either (enum [ "all" ]) (
            listOf (enum [
              "fix_all"
              "add_missing_imports"
              "remove_unused"
              "remove_unused_imports"
              "organize_imports"
              "insert_leave"
            ])
          );
        default = [ ];
        description = "Specify what to expose as code actions.";
      };

      tsserver_path = lib.nixvim.mkNullOrStr ''
        Specify a custom path to `tsserver.js` file, if this is nil or file under path
        doesn't exist then standard path resolution strategy is applied
      '';

      tsserver_plugins =
        with lib.types;
        lib.nixvim.mkNullOrOption (listOf (maybeRaw str)) ''
          List of plugins for tsserver to load. See this plugins's README
          at https://github.com/pmizio/typescript-tools.nvim/#-styled-components-support
        '';

      tsserver_max_memory =
        lib.nixvim.mkNullOrOption (with lib.types; maybeRaw (either ints.unsigned (enum [ "auto" ])))
          ''
            This value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
            Memory limit in megabytes or "auto"(basically no limit)
          '';

      tsserver_format_options = lib.mkOption {
        type = with lib.types; nullOr (attrsOf anything);
        default = null;
        description = "Configuration options that well be passed to the tsserver instance. Find available options [here](https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3418)";
        example = {
          "tsserver_file_preferences" = ''
            {
              includeInlayParameterNameHints = "all",
              includeCompletionsForModuleExports = true,
              quotePreference = "auto",
              ...
            }
          '';
        };
      };

      tsserver_file_references = lib.mkOption {
        type = with lib.types; nullOr (attrsOf anything);
        default = null;
        description = "Configuration options that well be passed to the tsserver instance. Find available options [here](https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3439)";
        example = {
          "tsserver_format_options" = ''
            {
              allowIncompleteCompletions = false,
              allowRenameOfImportPath = false,
              ...
            }'';
        };
      };

      tsserver_locale = defaultNullOpts.mkStr "en" ''
        Locale of all tsserver messages. Supported locales here: https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
      '';

      complete_function_calls = defaultNullOpts.mkBool false ''
        Mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      '';

      include_completions_with_insert_text = defaultNullOpts.mkBool true ''
        Mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      '';

      codeLens =
        defaultNullOpts.mkEnum
          [
            "off"
            "all"
            "implementations_only"
            "references_only"
          ]
          "off"
          "WARNING: Experimental feature also in VSCode, disabled by default because it might impact server performance.";

      disable_member_code_lens = defaultNullOpts.mkBool true ''
        By default code lenses are displayed on all referenceable values. Display less by removing member references from lenses.
      '';

      jsx_close_tag = {
        enable = defaultNullOpts.mkBool false ''
          Functions similarly to `nvim-ts-autotag`. This is disabled by default to avoid conflicts.
        '';
        filetypes =
          defaultNullOpts.mkListOf lib.types.str
            [
              "javascriptreact"
              "typescriptreact"
            ]
            ''
              Filetypes this should apply to.
            '';
      };
    };
  };

  settingsExample = {
    handlers = {
      "textDocument/publishDiagnostics" = ''
        api.filter_diagnostics(
          { 80006 }
        )
      '';
    };
    settings = {
      tsserver_plugins = [
        "@styled/typescript-styled-plugin"
      ];
      tsserver_file_preferences.__raw = ''
        function(ft)
          return {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          }
        end
      '';
      tsserver_format_options.__raw = ''
        function(ft)
          return {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
          }
        end
      '';
    };
  };

  # Set up after lspconfig
  configLocation = "extraConfigLuaPost";
}
