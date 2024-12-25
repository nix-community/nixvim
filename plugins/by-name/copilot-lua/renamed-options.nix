let
  panelOptions = [
    "enabled"
    "autoRefresh"
  ];
  panelKeymapOptions = [
    "jumpPrev"
    "jumpNext"
    "accept"
    "refresh"
    "open"
  ];
  panelLayoutOptions = [
    "position"
    "ratio"
  ];
  suggestionOptions = [
    "enabled"
    "autoTrigger"
    "debounce"
  ];
  suggestionKeymapOptions = [
    "accept"
    "acceptWord"
    "acceptLine"
    "next"
    "prev"
    "dismiss"
  ];
in
[
  "filetypes"
  "copilotNodeCommand"
  "serverOptsOverrides"
]
++ map (oldOption: [
  "panel"
  oldOption
]) panelOptions
++ map (oldOption: [
  "panel"
  "keymap"
  oldOption
]) panelKeymapOptions
++ map (oldOption: [
  "panel"
  "layout"
  oldOption
]) panelLayoutOptions
++ map (oldOption: [
  "suggestion"
  oldOption
]) suggestionOptions
++ map (oldOption: [
  "suggestion"
  "keymap"
  oldOption
]) suggestionKeymapOptions
