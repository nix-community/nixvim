{
  lib,
  config,
  ...
}:
let
  cfg = config.plugins.lsp.servers.svelte;
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
  inherit (lib) types;
in
{
  # Options: https://github.com/sveltejs/language-tools/tree/master/packages/language-server#settings
  options.plugins.lsp.servers.svelte.initOptions = {
    svelte = {
      plugin = {
        typescript = {
          enable = defaultNullOpts.mkBool true "Enable the TypeScript plugin.";

          diagnostics = {
            enable = defaultNullOpts.mkBool true ''
              Enable diagnostic messages for TypeScript.
            '';
          };

          hover = {
            enable = defaultNullOpts.mkBool true ''
              Enable hover info for TypeScript.
            '';
          };

          documentSymbols = {
            enable = defaultNullOpts.mkBool true ''
              Enable document symbols for TypeScript.
            '';
          };

          completions = {
            enable = defaultNullOpts.mkBool true ''
              Enable completions for TypeScript.
            '';
          };

          codeActions = {
            enable = defaultNullOpts.mkBool true ''
              Enable code actions for TypeScript.
            '';
          };

          selectionRange = {
            enable = defaultNullOpts.mkBool true ''
              Enable selection range for TypeScript.
            '';
          };

          signatureHelp = {
            enable = defaultNullOpts.mkBool true ''
              Enable signature help (parameter hints) for JS/TS.
            '';
          };

          semanticTokens = {
            enable = defaultNullOpts.mkBool true ''
              Enable semantic tokens (semantic highlight) for TypeScript.
            '';
          };
        };

        css = {
          enable = defaultNullOpts.mkBool true "Enable the CSS plugin.";

          globals = mkNullOrOption types.str ''
            Which css files should be checked for global variables (`--global-var: value;`).
            These variables are added to the css completions.
            String of comma-separated file paths or globs relative to workspace root.
          '';

          diagnostics = {
            enable = defaultNullOpts.mkBool true ''
              Enable diagnostic messages for CSS.
            '';
          };

          hover = {
            enable = defaultNullOpts.mkBool true ''
              Enable hover info for CSS.
            '';
          };

          completions = {
            enable = defaultNullOpts.mkBool true ''
              Enable completions for CSS.
            '';

            emmet = defaultNullOpts.mkBool true ''
              Enable emmet auto completions for CSS.
            '';
          };

          documentColors = {
            enable = defaultNullOpts.mkBool true ''
              Enable document colors for CSS.
            '';
          };

          colorPresentations = {
            enable = defaultNullOpts.mkBool true ''
              Enable color picker for CSS.
            '';
          };

          documentSymbols = {
            enable = defaultNullOpts.mkBool true ''
              Enable document symbols for CSS.
            '';
          };

          selectionRange = {
            enable = defaultNullOpts.mkBool true ''
              Enable selection range for CSS.
            '';
          };
        };

        html = {
          enable = defaultNullOpts.mkBool true "Enable the HTML plugin.";

          hover = {
            enable = defaultNullOpts.mkBool true ''
              Enable hover info for HTML.
            '';
          };

          completions = {
            enable = defaultNullOpts.mkBool true ''
              Enable completions for HTML.
            '';

            emmet = defaultNullOpts.mkBool true ''
              Enable emmet auto completions for HTML.
            '';
          };

          tagComplete = {
            enable = defaultNullOpts.mkBool true ''
              Enable tag auto closing.
            '';
          };

          documentSymbols = {
            enable = defaultNullOpts.mkBool true ''
              Enable document symbols for HTML.
            '';
          };

          linkedEditing = {
            enable = defaultNullOpts.mkBool true ''
              Enable Linked Editing for HTML.
            '';
          };
        };

        svelte = {
          enable = defaultNullOpts.mkBool true "Enable the Svelte plugin.";

          diagnostics = {
            enable = defaultNullOpts.mkBool true ''
              Enable diagnostic messages for Svelte.
            '';
          };

          compilerWarnings = mkNullOrOption (with types; attrsOf str) ''
            Svelte compiler warning codes to ignore or to treat as errors.
            Example:
            ```
            {
              css-unused-selector = "ignore";
              unused-export-let = "error";
            }
          '';

          format = {
            enable = defaultNullOpts.mkBool true ''
              Enable formatting for Svelte (includes css & js) using `prettier-plugin-svelte`.

              You can set some formatting options through this extension.
              They will be ignored if there's any kind of configuration file, for example a
              `.prettierrc` file.
            '';

            config = {
              svelteSortOrder = defaultNullOpts.mkStr "options-scripts-markup-styles" ''
                Format: join the keys `options`, `scripts`, `markup`, `styles` with a `-` in the
                order you want.

                This option is ignored if there's any kind of configuration file, for example a
                `.prettierrc` file.
              '';
              svelteStrictMode = defaultNullOpts.mkBool false ''
                More strict HTML syntax.

                This option is ignored if there's any kind of configuration file, for example a
                `.prettierrc` file.
              '';

              svelteAllowShorthand = defaultNullOpts.mkBool true ''
                Option to enable/disable component attribute shorthand if attribute name and
                expression are the same.

                This option is ignored if there's any kind of configuration file, for example a
                `.prettierrc` file.
              '';

              svelteBracketNewLine = defaultNullOpts.mkBool true ''
                Put the `>` of a multiline element on a new line.

                This option is ignored if there's any kind of configuration file, for example a
                `.prettierrc` file.
              '';

              svelteIndentScriptAndStyle = defaultNullOpts.mkBool true ''
                Whether or not to indent code inside `<script>` and `<style>` tags.

                This option is ignored if there's any kind of configuration file, for example a
                `.prettierrc` file.
              '';

              printWidth = defaultNullOpts.mkInt 80 ''
                Maximum line width after which code is tried to be broken up.

                This is a Prettier core option.
                If you have the Prettier extension installed, this option is ignored and the
                corresponding option of that extension is used instead.
                This option is also ignored if there's any kind of configuration file, for example a
                `.prettierrc` file.
              '';

              singleQuote = defaultNullOpts.mkBool false ''
                Use single quotes instead of double quotes, where possible.

                This is a Prettier core option.
                If you have the Prettier extension installed, this option is ignored and the
                corresponding option of that extension is used instead.
                This option is also ignored if there's any kind of configuration file, for example a
                `.prettierrc` file.
              '';
            };
          };

          hover = {
            enable = defaultNullOpts.mkBool true ''
              Enable hover info for Svelte (for tags like `#if`/`#each`).
            '';
          };

          completions = {
            enable = defaultNullOpts.mkBool true ''
              Enable completions for TypeScript.
              Enable autocompletion for Svelte (for tags like `#if`/`#each`).
            '';
          };

          rename = {
            enable = defaultNullOpts.mkBool true ''
              Enable rename/move Svelte files functionality.
            '';
          };

          codeActions = {
            enable = defaultNullOpts.mkBool true ''
              Enable code actions for Svelte.
            '';
          };

          selectionRange = {
            enable = defaultNullOpts.mkBool true ''
              Enable selection range for Svelte.
            '';
          };

          defaultScriptLanguage = mkNullOrOption types.str ''
            The default language to use when generating new script tags in Svelte.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    plugins.lsp.servers.svelte.extraOptions.init_options = {
      configuration = cfg.initOptions;
    };
  };
}
