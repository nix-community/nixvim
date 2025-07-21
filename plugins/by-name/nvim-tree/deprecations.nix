lib: {
  imports = [
    (
      let
        oldOptPath = [
          "plugins"
          "nvim-tree"
          "view"
          "hideRootFolder"
        ];
      in
      lib.mkChangedOptionModule oldOptPath [
        "plugins"
        "nvim-tree"
        "settings"
        "renderer"
        "root_folder_label"
      ] (config: !lib.getAttrFromPath oldOptPath config)
    )

    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "nvim-tree";
      packageName = "git";
    })
  ];

  # Deprecations after mkNeovimPlugin migration, added 2025-07-21
  deprecateExtraOptions = true;

  optionsRenamedToSettings = map (lib.splitString ".") [
    "disableNetrw"
    "hijackNetrw"
    "autoReloadOnWrite"
    "sortBy"
    "hijackUnnamedBufferWhenOpening"
    "hijackCursor"
    "rootDirs"
    "preferStartupRoot"
    "syncRootWithCwd"
    "reloadOnBufenter"
    "respectBufCwd"

    "hijackDirectories.enable"
    "hijackDirectories.autoOpen"

    "updateFocusedFile.enable"
    "updateFocusedFile.updateRoot"
    "updateFocusedFile.ignoreList"

    "systemOpen.cmd"
    "systemOpen.args"

    "diagnostics.enable"
    "diagnostics.debounceDelay"
    "diagnostics.showOnDirs"
    "diagnostics.showOnOpenDirs"
    "diagnostics.icons.hint"
    "diagnostics.icons.info"
    "diagnostics.icons.warning"
    "diagnostics.icons.error"
    "diagnostics.severity.min"
    "diagnostics.severity.max"

    "git.enable"
    "git.ignore"
    "git.showOnDirs"
    "git.showOnOpenDirs"
    "git.timeout"

    "modified.enable"
    "modified.showOnDirs"
    "modified.showOnOpenDirs"

    "filesystemWatchers.enable"
    "filesystemWatchers.debounceDelay"
    "filesystemWatchers.ignoreDirs"

    "onAttach"
    "selectPrompts"

    "view.centralizeSelection"
    "view.cursorline"
    "view.debounceDelay"
    "view.width"
    "view.side"
    "view.preserveWindowProportions"
    "view.number"
    "view.relativenumber"
    "view.signcolumn"

    "view.float.enable"
    "view.float.quitOnFocusLoss"
    "view.float.openWinConfig"

    "renderer.addTrailing"
    "renderer.groupEmpty"
    "renderer.fullName"
    "renderer.highlightGit"
    "renderer.highlightOpenedFiles"
    "renderer.highlightModified"
    "renderer.rootFolderLabel"
    "renderer.indentWidth"
    "renderer.indentMarkers.enable"
    "renderer.indentMarkers.inlineArrows"
    "renderer.indentMarkers.icons.corner"
    "renderer.indentMarkers.icons.edge"
    "renderer.indentMarkers.icons.item"
    "renderer.indentMarkers.icons.bottom"
    "renderer.indentMarkers.icons.none"
    "renderer.icons.webdevColors"
    "renderer.icons.gitPlacement"
    "renderer.icons.modifiedPlacement"
    "renderer.icons.padding"
    "renderer.icons.symlinkArrow"
    "renderer.icons.show.file"
    "renderer.icons.show.folder"
    "renderer.icons.show.folderArrow"
    "renderer.icons.show.git"
    "renderer.icons.show.modified"
    "renderer.icons.glyphs.default"
    "renderer.icons.glyphs.symlink"
    "renderer.icons.glyphs.modified"
    "renderer.icons.glyphs.folder.arrowClosed"
    "renderer.icons.glyphs.folder.arrowOpen"
    "renderer.icons.glyphs.folder.default"
    "renderer.icons.glyphs.folder.open"
    "renderer.icons.glyphs.folder.empty"
    "renderer.icons.glyphs.folder.emptyOpen"
    "renderer.icons.glyphs.folder.symlink"
    "renderer.icons.glyphs.folder.symlinkOpen"
    "renderer.icons.glyphs.git.unstaged"
    "renderer.icons.glyphs.git.staged"
    "renderer.icons.glyphs.git.unmerged"
    "renderer.icons.glyphs.git.renamed"
    "renderer.icons.glyphs.git.untracked"
    "renderer.icons.glyphs.git.deleted"
    "renderer.icons.glyphs.git.ignored"
    "renderer.specialFiles"
    "renderer.symlinkDestination"

    "filters.dotfiles"
    "filters.gitClean"
    "filters.noBuffer"
    "filters.custom"
    "filters.exclude"

    "trash.cmd"

    "actions.changeDir.enable"
    "actions.changeDir.global"
    "actions.changeDir.restrictAboveCwd"
    "actions.expandAll.maxFolderDiscovery"
    "actions.expandAll.exclude"
    "actions.filePopup.openWinConfig"
    "actions.openFile.quitOnOpen"
    "actions.openFile.resizeWindow"
    "actions.windowPicker.enable"
    "actions.windowPicker.picker"
    "actions.windowPicker.chars"
    "actions.windowPicker.exclude"
    "actions.removeFile.closeWindow"
    "actions.useSystemClipboard"

    "liveFilter.prefix"
    "liveFilter.alwaysShowFolders"

    "tab.sync.open"
    "tab.sync.close"
    "tab.sync.ignore"

    "notify.threshold"

    "ui.confirm.remove"
    "ui.confirm.trash"

    "log.enable"
    "log.truncate"
    "log.types.all"
    "log.types.profile"
    "log.types.config"
    "log.types.copyPaste"
    "log.types.dev"
    "log.types.diagnostics"
    "log.types.git"
    "log.types.watcher"
  ];
}
