{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "typescript-tools";
  packPathName = "typescript-tools.nvim";
  package = "typescript-tools-nvim";
  description = "A collection of tools for working with TypeScript and JavaScript in Neovim, including LSP support, code actions, and more.";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO:: introduced 10-22-2024: remove after 24.11
  optionsRenamedToSettings = [
    "onAttach"
    "handlers"
  ];

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

  # NOTE: call setup manually
  callSetup = false;
  # Set up after lspconfig
  configLocation = "extraConfigLuaPost";
  extraConfig =
    cfg:
    let
      definedOpts = lib.filter (opt: lib.hasAttrByPath opt cfg.settings) [
        [ "separateDiagnosticServer" ]
        [ "publishDiagnosticOn" ]
        [ "exposeAsCodeAction" ]
        [ "tsserverPath" ]
        [ "tsserverPlugins" ]
        [ "tsserverMaxMemory" ]
        [ "tsserverFormatOptions" ]
        [ "tsserverFilePreferences" ]
        [ "tsserverLocale" ]
        [ "completeFunctionCalls" ]
        [ "includeCompletionsWithInsertText" ]
        [ "codeLens" ]
        [ "disableMemberCodeLens" ]
        [
          "jsxCloseTag"
          "enable"
        ]
        [
          "jsxCloseTag"
          "filetypes"
        ]
      ];
    in
    {
      plugins.typescript-tools.luaConfig.content =
        let
          # TODO:: introduced 10-22-2024: remove after 24.11
          renamedSettings = lib.foldl' (
            acc: optPath:
            let
              snakeCasePath = builtins.map lib.nixvim.toSnakeCase optPath;
              optValue = lib.getAttrFromPath optPath cfg.settings;
            in
            lib.recursiveUpdate acc (lib.setAttrByPath snakeCasePath optValue)
          ) { } definedOpts;

          # Based on lib.filterAttrsRecursive
          # TODO: Maybe move to nixvim's or upstream's lib?
          filterAttrsRecursivePath =
            predicate: set: path:
            lib.listToAttrs (
              lib.concatMap (
                name:
                let
                  path' = path ++ [ name ];
                  v = set.${name};
                in
                lib.optional (predicate path' v) {
                  inherit name;
                  value = if lib.isAttrs v then filterAttrsRecursivePath predicate v path' else v;
                }
              ) (lib.attrNames set)
            );

          setupOptions =
            filterAttrsRecursivePath (path: _: !builtins.elem path definedOpts) cfg.settings [ ]
            // {
              settings = lib.recursiveUpdate cfg.settings.settings renamedSettings;
            };
        in
        ''
          require('typescript-tools').setup(${lib.nixvim.toLuaObject setupOptions})
        '';

      # TODO:: introduced 10-22-2024: remove after 24.11
      # Nested settings can't have normal mkRenamedOptionModule functionality so we can only
      # alert the user that they are using the old values
      warnings = lib.nixvim.mkWarnings "plugins.typescript-tools" {
        when = definedOpts != [ ];
        message = ''
          The following settings have moved under `plugins.typescript-tools.settings.settings` with snake_case:
          ${lib.concatMapStringsSep "\n" (opt: "  - ${lib.showOption (lib.toList opt)}") definedOpts}
        '';
      };
    };
}
