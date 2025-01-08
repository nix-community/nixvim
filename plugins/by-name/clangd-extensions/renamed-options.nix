let
  inlayHintsOptions = [
    "inline"
    "onlyCurrentLine"
    "onlyCurrentLineAutocmd"
    "showParameterHints"
    "parameterHintsPrefix"
    "otherHintsPrefix"
    "maxLenAlign"
    "maxLenAlignPadding"
    "rightAlign"
    "rightAlignPadding"
    "highlight"
    "priority"
  ];
  astOptions = [
    "roleIcons"
    "kindIcons"
    "highlights"
  ];
in
[
  "memoryUsage"
  "symbolInfo"
]
++ map (oldOption: [
  "inlayHints"
  oldOption
]) inlayHintsOptions
++ map (oldOption: [
  "ast"
  oldOption
]) astOptions
