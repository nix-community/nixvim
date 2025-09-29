lib: {
  deprecateExtraOptions = true;

  optionsRenamedToSettings = [
    "builtinMarks"
    "defaultMappings"
    "signs"
    "cyclic"
    "forceWriteShada"
    "refreshInterval"
    "signPriority"
    "excludedFiletypes"
    "excludedBuftypes"
    "mappings"
  ];

  imports = [
    (lib.mkRemovedOptionModule [ "plugins" "marks" "bookmarks" ] ''
      This option always caused a failed assertion, it has never worked.
      You can now define bookmarks using `settings.bookmark_<num>` where num is a number from 0 to 9.
    '')
  ];
}
