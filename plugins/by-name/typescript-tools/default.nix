{
  lib,
  pkgs,
  helpers,
  config,
  ...
}:
with lib;
let
  cfg = config.plugins.typescript-tools;
in
{
  options.plugins.typescript-tools = {
    enable = mkEnableOption "typescript-tools";
    package = lib.mkPackageOption pkgs "typescript-tools" {
      default = [
        "vimPlugins"
        "typescript-tools-nvim"
      ];
    };

    onAttach = helpers.defaultNullOpts.mkLuaFn "__lspOnAttach" "Lua code to run when tsserver attaches to a buffer.";
    handlers = mkOption {
      type = with lib.types; nullOr (attrsOf strLuaFn);
      apply = v: helpers.ifNonNull' v (mapAttrs (_: helpers.mkRaw) v);
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
      separateDiagnosticServer = helpers.defaultNullOpts.mkBool true "Spawns an additional tsserver instance to calculate diagnostics";

      publishDiagnosticOn =
        helpers.defaultNullOpts.mkEnum
          [
            "change"
            "insert_leave"
          ]
          "insert_leave"
          ''
            Either "change" or "insert_leave". Determines when the client asks the server about diagnostics
          '';

      exposeAsCodeAction = mkOption {
        type =
          with types;
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

      tsserverPath = helpers.mkNullOrStr ''
        Specify a custom path to `tsserver.js` file, if this is nil or file under path
        doesn't exist then standard path resolution strategy is applied
      '';

      tsserverPlugins =
        with lib.types;
        helpers.mkNullOrOption (listOf (maybeRaw str)) ''
          List of plugins for tsserver to load. See this plugins's README
          at https://github.com/pmizio/typescript-tools.nvim/#-styled-components-support
        '';

      tsserverMaxMemory =
        helpers.mkNullOrOption (with lib.types; maybeRaw (either ints.unsigned (enum [ "auto" ])))
          ''
            This value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
            Memory limit in megabytes or "auto"(basically no limit)
          '';

      tsserverFormatOptions = mkOption {
        type = with types; nullOr (attrsOf anything);
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

      tsserverFilePreferences = mkOption {
        type = with types; nullOr (attrsOf anything);
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

      tsserverLocale = helpers.defaultNullOpts.mkStr "en" ''
        Locale of all tsserver messages. Supported locales here: https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
      '';

      completeFunctionCalls = helpers.defaultNullOpts.mkBool false ''
        Mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      '';

      includeCompletionsWithInsertText = helpers.defaultNullOpts.mkBool true ''
        Mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      '';

      codeLens =
        helpers.defaultNullOpts.mkEnum
          [
            "off"
            "all"
            "implementations_only"
            "references_only"
          ]
          "off"
          "WARNING: Experimental feature also in VSCode, disabled by default because it might impact server performance.";

      disableMemberCodeLens = helpers.defaultNullOpts.mkBool true ''
        By default code lenses are displayed on all referenceable values. Display less by removing member references from lenses.
      '';

      jsxCloseTag = {
        enable = helpers.defaultNullOpts.mkBool false ''
          Functions similarly to `nvim-ts-autotag`. This is disabled by default to avoid conflicts.
        '';
        filetypes =
          helpers.defaultNullOpts.mkListOf types.str
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
  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    plugins.lsp.postConfig =
      with cfg;
      let
        options = {
          inherit handlers;
          on_attach = onAttach;

          settings = with settings; {
            separate_diagnostic_server = separateDiagnosticServer;
            publish_diagnostic_on = publishDiagnosticOn;
            expose_as_code_action = exposeAsCodeAction;
            tsserver_path = tsserverPath;
            tsserver_plugins = tsserverPlugins;
            tsserver_max_memory = tsserverMaxMemory;
            tsserver_format_options = tsserverFormatOptions;
            tsserver_file_preferences = tsserverFilePreferences;
            tsserver_locale = tsserverLocale;
            complete_function_calls = completeFunctionCalls;
            include_completions_with_insert_text = includeCompletionsWithInsertText;
            code_lens = codeLens;
            disable_member_code_lens = disableMemberCodeLens;
            jsx_close_tag = with jsxCloseTag; {
              inherit enable filetypes;
            };
          };
        };
      in
      ''
        require('typescript-tools').setup(${helpers.toLuaObject options})
      '';
  };
}
