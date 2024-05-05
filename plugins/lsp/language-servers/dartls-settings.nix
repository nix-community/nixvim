{ lib, helpers }:
with lib;
{
  analysisExcludedFolders = helpers.mkNullOrOption (with types; listOf str) ''
    An array of paths (absolute or relative to each workspace folder) that should be excluded from
    analysis.
  '';

  enableSdkFormatter = helpers.mkNullOrOption types.bool ''
    When set to false, prevents registration (or unregisters) the SDK formatter.
    When set to true or not supplied, will register/reregister the SDK formatter
  '';

  lineLength = helpers.mkNullOrOption types.ints.unsigned ''
    The number of characters the formatter should wrap code at.
    If unspecified, code will be wrapped at 80 characters.
  '';

  completeFunctionCalls = helpers.mkNullOrOption types.bool ''
    When set to true, completes functions/methods with their required parameters.
  '';

  showTodos = helpers.mkNullOrOption types.bool ''
    Whether to generate diagnostics for TODO comments.
    If unspecified, diagnostics will not be generated.
  '';

  renameFilesWithClasses =
    helpers.mkNullOrOption
      (types.enum [
        "always"
        "prompt"
      ])
      ''
        When set to "always", will include edits to rename files when classes are renamed if the
        filename matches the class name (but in snake_form).
        When set to "prompt", a prompt will be shown on each class rename asking to confirm the file
        rename.
        Otherwise, files will not be renamed.
        Renames are performed using LSP's `ResourceOperation` edits - that means the rename is simply
        included in the resulting `WorkspaceEdit` and must be handled by the client.
      '';

  enableSnippets = helpers.mkNullOrOption types.bool ''
    Whether to include code snippets (such as class, stful, switch) in code completion.
    When unspecified, snippets will be included.
  '';

  updateImportsOnRename = helpers.mkNullOrOption types.bool ''
    Whether to update imports and other directives when files are renamed.
    When unspecified, imports will be updated if the client supports `willRenameFiles` requests.
  '';

  documentation =
    helpers.mkNullOrOption
      (types.enum [
        "none"
        "summary"
        "full"
      ])
      ''
        The typekind of dartdocs to include in Hovers, Code Completion, Signature Help and other similar
        requests.
        If not set, defaults to `"full"`.
      '';

  includeDependenciesInWorkspaceSymbols = helpers.mkNullOrOption types.bool ''
    Whether to include symbols from dependencies and Dart/Flutter SDKs in Workspace Symbol results.
    If not set, defaults to true.
  '';
}
