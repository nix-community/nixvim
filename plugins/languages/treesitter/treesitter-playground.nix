{lib, ...}:
with lib; {
  # Deprecation notice added 2023/08/29
  # TODO: remove (along with this file) in early November 2023.
  imports = [
    (
      mkRemovedOptionModule
      ["plugins" "treesitter-playground"]
      ''
        The `treesitter-playground` plugin has been deprecated since the functionality is included in Neovim.
        Use:
        - `:Inspect` to show the highlight groups under the cursor
        - `:InspectTree` to show the parsed syntax tree ("TSPlayground")
        - `:PreviewQuery` to open the Query Editor (Nvim 0.10+)
      ''
    )
  ];
}
