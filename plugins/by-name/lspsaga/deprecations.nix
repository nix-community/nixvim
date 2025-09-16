lib: {
  imports = [
    # TODO: introduced 2025-08-20: remove after 25.11
    (
      let
        oldOptPath = [
          "plugins"
          "lspsaga"
          "finder"
          "filter"
        ];
      in
      lib.mkChangedOptionModule oldOptPath
        [
          "plugins"
          "lspsaga"
          "settings"
          "finder"
          "filter"
        ]
        (
          config:
          let
            oldFilter = lib.getAttrFromPath oldOptPath config;
          in
          lib.nixvim.ifNonNull' oldFilter (lib.mapAttrs (_: lib.nixvim.mkRaw) oldFilter)
        )
    )

    # TODO: added 2024-09-20 remove after 24.11
    (
      { config, ... }:
      let
        cfg = config.plugins.lspsaga;
      in
      {
        plugins.web-devicons =
          lib.mkIf
            (
              cfg.enable
              && (cfg.settings.ui.devicon or true)
              && !(
                (
                  config.plugins.mini.enable
                  && config.plugins.mini.modules ? icons
                  && config.plugins.mini.mockDevIcons
                )
                || (config.plugins.mini-icons.enable && config.plugins.mini-icons.mockDevIcons)
              )
            )
            {
              enable = lib.mkOverride 1490 true;
            };
      }
    )
  ];

  # TODO: introduced 2025-08-20: remove after 25.11
  deprecateExtraOptions = true;
  optionsRenamedToSettings = map (lib.splitString ".") [
    "ui.border"
    "ui.devicon"
    "ui.title"
    "ui.expand"
    "ui.collapse"
    "ui.codeAction"
    "ui.actionfix"
    "ui.lines"
    "ui.kind"
    "ui.impSign"

    "hover.maxWidth"
    "hover.maxHeight"
    "hover.openLink"
    "hover.openCmd"

    "diagnostic.showCodeAction"
    "diagnostic.showLayout"
    "diagnostic.showNormalHeight"
    "diagnostic.jumpNumShortcut"
    "diagnostic.maxWidth"
    "diagnostic.maxHeight"
    "diagnostic.maxShowWidth"
    "diagnostic.maxShowHeight"
    "diagnostic.textHlFollow"
    "diagnostic.borderFollow"
    "diagnostic.extendRelatedInformation"
    "diagnostic.diagnosticOnlyCurrent"
    "diagnostic.keys.execAction"
    "diagnostic.keys.quit"
    "diagnostic.keys.toggleOrJump"
    "diagnostic.keys.quitInShow"

    "codeAction.numShortcut"
    "codeAction.showServerName"
    "codeAction.extendGitSigns"
    "codeAction.onlyInCursor"
    "codeAction.keys.quit"
    "codeAction.keys.exec"

    "lightbulb.enable"
    "lightbulb.sign"
    "lightbulb.debounce"
    "lightbulb.signPriority"
    "lightbulb.virtualText"

    "scrollPreview.scrollDown"
    "scrollPreview.scrollUp"

    "finder.maxHeight"
    "finder.leftWidth"
    "finder.rightWidth"
    "finder.methods"
    "finder.default"
    "finder.layout"
    "finder.silent"
    "finder.keys.shuttle"
    "finder.keys.toggleOrOpen"
    "finder.keys.vsplit"
    "finder.keys.split"
    "finder.keys.tabe"
    "finder.keys.tabnew"
    "finder.keys.quit"
    "finder.keys.close"

    "definition.width"
    "definition.height"
    "definition.keys.edit"
    "definition.keys.vsplit"
    "definition.keys.split"
    "definition.keys.tabe"
    "definition.keys.quit"
    "definition.keys.close"

    "rename.inSelect"
    "rename.autoSave"
    "rename.projectMaxWidth"
    "rename.projectMaxHeight"
    "rename.keys.quit"
    "rename.keys.exec"
    "rename.keys.select"

    "symbolInWinbar.enable"
    "symbolInWinbar.separator"
    "symbolInWinbar.hideKeyword"
    "symbolInWinbar.showFile"
    "symbolInWinbar.folderLevel"
    "symbolInWinbar.colorMode"
    "symbolInWinbar.delay"

    "outline.winPosition"
    "outline.winWidth"
    "outline.autoPreview"
    "outline.detail"
    "outline.autoClose"
    "outline.closeAfterJump"
    "outline.layout"
    "outline.maxHeight"
    "outline.leftWidth"
    "outline.keys.toggleOrJump"
    "outline.keys.quit"
    "outline.keys.jump"

    "callhierarchy.layout"
    "callhierarchy.keys.edit"
    "callhierarchy.keys.vsplit"
    "callhierarchy.keys.split"
    "callhierarchy.keys.tabe"
    "callhierarchy.keys.close"
    "callhierarchy.keys.quit"
    "callhierarchy.keys.shuttle"
    "callhierarchy.keys.toggleOrReq"

    "implement.enable"
    "implement.sign"
    "implement.virtualText"
    "implement.priority"

    "beacon.enable"
    "beacon.frequency"
  ];
}
