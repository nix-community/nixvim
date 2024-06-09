{ lib, helpers }:
with lib;
# https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/neovim/Configuration.md
{
  outputPath = helpers.defaultNullOpts.mkStr "$dir/$name" ''
    The path pattern to store Typst artifacts, you can use `$root` or `$dir` or `$name` to do magic
    configuration, e.g. `$dir/$name` (default) and `$root/target/$dir/$name`.
  '';

  exportPdf =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "auto"
        "never"
        "onSave"
        "onType"
        "onDocumentHasTitle"
      ]
      ''
        The extension can export PDFs of your Typst files.
        This setting controls whether this feature is enabled and how often it runs.

          - `auto`: Select best solution automatically. (Recommended)
          - `never`: Never export PDFs, you will manually run typst.
          - `onSave`: Export PDFs when you save a file.
          - `onType`: Export PDFs as you type in a file.
          - `onDocumentHasTitle`: Export PDFs when a document has a title (and save a file), which is useful to filter out template files.
      '';

  rootPath = helpers.mkNullOrStr ''
    Configure the root for absolute paths in typst.
  '';

  semanticTokens =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "enable"
        "disable"
      ]
      ''
        Enable or disable semantic tokens (LSP syntax highlighting).

          - `enable`: Use semantic tokens for syntax highlighting
          - `disable`: Do not use semantic tokens for syntax highlighting
      '';

  systemFonts = helpers.defaultNullOpts.mkBool true ''
    A flag that determines whether to load system fonts for Typst compiler, which is useful for
    ensuring reproducible compilation.
    If set to null or not set, the extension will use the default behavior of the Typst compiler.
  '';

  fontPaths = helpers.defaultNullOpts.mkListOf types.str [ ] ''
    Font paths, which doesn't allow for dynamic configuration.
    Note: you can use vscode variables in the path, e.g. `$\{workspaceFolder}/fonts`.
  '';

  compileStatus =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "enable"
        "disable"
      ]
      ''
        In VSCode, enable compile status meaning that the extension will show the compilation status in
        the status bar.

        Since neovim and helix don't have a such feature, it is disabled by default at the language
        server level.
      '';

  typstExtraArgs = helpers.defaultNullOpts.mkListOf types.str [ ] ''
    You can pass any arguments as you like, and we will try to follow behaviors of the
    **same version** of typst-cli.

    Note: the arguments may be overridden by other settings.
    For example, `--font-path` will be overridden by `tinymist.fontPaths`.
  '';

  serverPath = helpers.mkNullOrStr ''
    The extension can use a local tinymist executable instead of the one bundled with the extension.
    This setting controls the path to the executable.
  '';

  "trace.server" =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "off"
        "messages"
        "verbose"
      ]
      ''
        Traces the communication between VS Code and the language server.
      '';

  formatterMode =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "disable"
        "typstyle"
        "typstfmt"
      ]
      ''
        The extension can format Typst files using typstfmt or typstyle.

          - `disable`: Formatter is not activated.
          - `typstyle`: Use typstyle formatter.
          - `typstfmt`: Use typstfmt formatter.
      '';

  formatterPrintWidth = helpers.defaultNullOpts.mkUnsignedInt 120 ''
    Set the print width for the formatter, which is a **soft limit** of characters per line.
    See [the definition of *Print Width*](https://prettier.io/docs/en/options.html#print-width).

    Note: this has lower priority than the formatter's specific configurations.
  '';
}
