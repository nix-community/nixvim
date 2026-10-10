{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "phpactor";
  package = "phpactor";

  globalPrefix = "phpactor";

  maintainers = [ lib.maintainers.opdavies ];

  description = ''
    Refactoring and introspection for PHP: scaffold classes, extract
    methods, and navigate symbols via Phpactor's context menu.

    This module covers the editor plugin only (the `:Phpactor*` commands
    and their `g:phpactor*` globals). For the language server, use
    `lsp.servers.phpactor` instead — the plugin is not required for that.

    Note: the option names for globals such as `g:phpactorPhpBin` and
    `g:phpactorBranch` are camel-cased upstream, so the settings keys keep
    their upstream casing after the `phpactor` prefix.
  '';

  settingsExample = {
    PhpBin = null;
    Branch = "main";
    InitialCwd = true;
    InputListStrategy = "phpactor#input#list#fzf";
    OmniAutoClassImport = true;
    CompletionIgnoreCase = false;
  };
}
