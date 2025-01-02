{ lib, ... }:
let
  inherit (lib) mkRemovedOptionModule;
in
{
  imports =
    map
      (
        oldOption:
        mkRemovedOptionModule
          [
            "plugins"
            "fidget"
            oldOption
          ]
          ''
            Nixvim: The fidget.nvim plugin has been completely rewritten. Hence, the options have changed.
            Please, take a look at the updated documentation and adapt your configuration accordingly.

            > https://github.com/j-hui/fidget.nvim
          ''
      )
      [
        "text"
        "align"
        "timer"
        "window"
        "fmt"
        "sources"
        "debug"
      ];

  optionsRenamedToSettings =
    let
      progressOptions = [
        "pollRate"
        "suppressOnInsert"
        "ignoreDoneAlready"
        "ignoreEmptyMessage"
        "notificationGroup"
        "clearOnDetach"
        "ignore"
      ];
      progressDisplayOptions = [
        "renderLimit"
        "doneTtl"
        "doneIcon"
        "doneStyle"
        "progressTtl"
        "progressIcon"
        "progressStyle"
        "groupStyle"
        "iconStyle"
        "priority"
        "skipHistory"
        "formatMessage"
        "formatAnnote"
        "formatGroupName"
        "overrides"
      ];
      notificationOptions = [
        "pollRate"
        "filter"
        "historySize"
        "overrideVimNotify"
        "configs"
        "redirect"
      ];
      notificationViewOptions = [
        "stackUpwards"
        "iconSeparator"
        "groupSeparator"
        "groupSeparatorHl"
      ];
      notificationWindowOptions = [
        "normalHl"
        "winblend"
        "border"
        "borderHl"
        "zindex"
        "maxWidth"
        "maxHeight"
        "xPadding"
        "yPadding"
        "align"
        "relative"
      ];
    in
    [
      [
        "progress"
        "lsp"
        "progressRingbufSize"
      ]
      [
        "integration"
        "nvim-tree"
        "enable"
      ]
      [
        "logger"
        "level"
      ]
      [
        "logger"
        "floatPrecision"
      ]
      [
        "logger"
        "path"
      ]
    ]
    ++ map (oldOption: [
      "progress"
      oldOption
    ]) progressOptions
    ++ map (oldOption: [
      "progress"
      "display"
      oldOption
    ]) progressDisplayOptions
    ++ map (oldOption: [
      "notification"
      oldOption
    ]) notificationOptions
    ++ map (oldOption: [
      "notification"
      "view"
      oldOption
    ]) notificationViewOptions
    ++ map (oldOption: [
      "notification"
      "window"
      oldOption
    ]) notificationWindowOptions;
}
