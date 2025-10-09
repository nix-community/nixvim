lib: {
  deprecateExtraOptions = true;

  imports =
    let
      mkRemovedOption =
        oldSubPath: newSubPath:
        let
          oldPath = [
            "plugins"
            "neo-tree"
          ]
          ++ (lib.splitString "." oldSubPath);

          message = ''
            Use `plugins.neo-tree.settings.${newSubPath}`.
            WARNINGS:
              - sub-option names are the upstream ones, and use snake_case:
                `displayName` -> `display_name`
              - Lua string are not automatically converted to lua:
                `foo = "vim.fn.stdpath('data')"` -> `foo.__raw = "vim.fn.stdpath('data')"`
          '';
        in
        lib.mkRemovedOptionModule oldPath message;
    in
    lib.mapAttrsToList mkRemovedOption {
      "sourceSelector.sources" = "source_selector.sources";
      "eventHandlers" = "event_handlers";
      "window.mappings" = "window.mappings";
      "renderers" = "renderers";
      "filesystem.window.mappings" = "filesystem.window.mappings";
      "filesystem.findArgs" = "filesystem.find_args";
      "buffers.window.mappings" = "buffers.window.mappings";
      "gitStatus.window.mappings" = "git_status.window.mappings";
      "example.renderers.custom" = "example.renderers.custom";
      "example.window.mappings" = "example.window.mappings";
      "documentSymbols.customKinds" = "document_symbols.custom_kinds";
      "documentSymbols.window.mappings" = "document_symbols.window.mappings";
    };

  optionsRenamedToSettings = [
    {
      old = "extraSources";
      new = "sources";
    }
  ]
  ++ (map (lib.splitString ".") [
    "sources"
    "addBlankLineAtTop"
    "autoCleanAfterSessionRestore"
    "closeIfLastWindow"
    "defaultSource"
    "enableDiagnostics"
    "enableGitStatus"
    "enableModifiedMarkers"
    "enableRefreshOnWrite"
    "gitStatusAsync"
    "gitStatusAsyncOptions.batchSize"
    "gitStatusAsyncOptions.batchDelay"
    "gitStatusAsyncOptions.maxLines"
    "hideRootNode"
    "retainHiddenRootIndent"
    "logLevel"
    "logToFile"
    "openFilesInLastWindow"
    "popupBorderStyle"
    "resizeTimerInterval"
    "sortCaseInsensitive"
    "sortFunction"
    "usePopupsForInput"
    "useDefaultMappings"

    "sourceSelector.winbar"
    "sourceSelector.statusline"
    "sourceSelector.showScrolledOffParentNode"
    "sourceSelector.contentLayout"
    "sourceSelector.tabsLayout"
    "sourceSelector.truncationCharacter"
    "sourceSelector.tabsMinWidth"
    "sourceSelector.tabsMaxWidth"
    "sourceSelector.padding"
    "sourceSelector.separator"
    "sourceSelector.separatorActive"
    "sourceSelector.showSeparatorOnEdge"
    "sourceSelector.highlightTab"
    "sourceSelector.highlightTabActive"
    "sourceSelector.highlightBackground"
    "sourceSelector.highlightSeparator"
    "sourceSelector.highlightSeparatorActive"

    "defaultComponentConfigs.container.enableCharacterFade"
    "defaultComponentConfigs.container.width"
    "defaultComponentConfigs.container.rightPadding"
    "defaultComponentConfigs.diagnostics"
    "defaultComponentConfigs.indent.indentSize"
    "defaultComponentConfigs.indent.padding"
    "defaultComponentConfigs.indent.withMarkers"
    "defaultComponentConfigs.indent.indentMarker"
    "defaultComponentConfigs.indent.lastIndentMarker"
    "defaultComponentConfigs.indent.highlight"
    "defaultComponentConfigs.indent.withExpanders"
    "defaultComponentConfigs.indent.expanderCollapsed"
    "defaultComponentConfigs.indent.expanderExpanded"
    "defaultComponentConfigs.indent.expanderHighlight"
    "defaultComponentConfigs.icon.folderClosed"
    "defaultComponentConfigs.icon.folderOpen"
    "defaultComponentConfigs.icon.folderEmpty"
    "defaultComponentConfigs.icon.folderEmptyOpen"
    "defaultComponentConfigs.icon.default"
    "defaultComponentConfigs.icon.highlight"
    "defaultComponentConfigs.modified"
    "defaultComponentConfigs.name.trailingSlash"
    "defaultComponentConfigs.name.useGitStatusColors"
    "defaultComponentConfigs.name.highlight"
    "defaultComponentConfigs.gitStatus.symbols.added"
    "defaultComponentConfigs.gitStatus.symbols.deleted"
    "defaultComponentConfigs.gitStatus.symbols.modified"
    "defaultComponentConfigs.gitStatus.symbols.renamed"
    "defaultComponentConfigs.gitStatus.symbols.untracked"
    "defaultComponentConfigs.gitStatus.symbols.ignored"
    "defaultComponentConfigs.gitStatus.symbols.unstaged"
    "defaultComponentConfigs.gitStatus.symbols.staged"
    "defaultComponentConfigs.gitStatus.symbols.conflict"
    "defaultComponentConfigs.gitStatus.align"

    "nestingRules"

    "window.position"
    "window.width"
    "window.height"
    "window.autoExpandWidth"
    "window.popup.size.height"
    "window.popup.size.width"
    "window.popup.position"
    "window.sameLevel"
    "window.insertAs"
    "window.mappingOptions.noremap"
    "window.mappingOptions.wait"

    "filesystem.asyncDirectoryScan"
    "filesystem.scanMode"
    "filesystem.bindToCwd"
    "filesystem.cwdTarget.sidebar"
    "filesystem.cwdTarget.current"
    "filesystem.filteredItems.visible"
    "filesystem.filteredItems.forceVisibleInEmptyFolder"
    "filesystem.filteredItems.showHiddenCount"
    "filesystem.filteredItems.hideDotfiles"
    "filesystem.filteredItems.hideGitignored"
    "filesystem.filteredItems.hideHidden"
    "filesystem.filteredItems.hideByName"
    "filesystem.filteredItems.hideByPattern"
    "filesystem.filteredItems.alwaysShow"
    "filesystem.filteredItems.neverShow"
    "filesystem.filteredItems.neverShowByPattern"
    "filesystem.findByFullPathWords"
    "filesystem.findCommand"
    "filesystem.groupEmptyDirs"
    "filesystem.searchLimit"
    "filesystem.followCurrentFile.enabled"
    "filesystem.followCurrentFile.leaveDirsOpen"
    "filesystem.hijackNetrwBehavior"
    "filesystem.useLibuvFileWatcher"

    "buffers.bindToCwd"
    "buffers.followCurrentFile.enabled"
    "buffers.followCurrentFile.leaveDirsOpen"
    "buffers.groupEmptyDirs"

    "documentSymbols.followCursor"
    "documentSymbols.kinds"
  ]);
}
