{ lib, ... }:
let
  inherit (lib) mkRemovedOptionModule mkRenamedOptionModule;
  basePluginPath = [
    "plugins"
    "clangd-extensions"
  ];
in
{
  imports = [
    (mkRemovedOptionModule (basePluginPath ++ [ "server" ]) ''
      To configure the `clangd` language server options, please use
      `plugins.lsp.servers.clangd.extraSettings`.
    '')
    (mkRemovedOptionModule (
      basePluginPath
      ++ [
        "extensions"
        "autoSetHints"
      ]
    ) "")
  ]
  ++ (map
    (
      optionPath:
      mkRenamedOptionModule (basePluginPath ++ [ "extensions" ] ++ optionPath) (
        basePluginPath ++ optionPath
      )
    )
    [
      [
        "inlayHints"
        "inline"
      ]
      [
        "inlayHints"
        "onlyCurrentLine"
      ]
      [
        "inlayHints"
        "onlyCurrentLineAutocmd"
      ]
      [
        "inlayHints"
        "showParameterHints"
      ]
      [
        "inlayHints"
        "parameterHintsPrefix"
      ]
      [
        "inlayHints"
        "otherHintsPrefix"
      ]
      [
        "inlayHints"
        "maxLenAlign"
      ]
      [
        "inlayHints"
        "maxLenAlignPadding"
      ]
      [
        "inlayHints"
        "rightAlign"
      ]
      [
        "inlayHints"
        "rightAlignPadding"
      ]
      [
        "inlayHints"
        "highlight"
      ]
      [
        "inlayHints"
        "priority"
      ]
      [ "ast" ]
      [ "memoryUsage" ]
      [ "symbolInfo" ]
    ]
  );
}
