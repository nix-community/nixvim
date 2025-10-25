lib: {
  imports = [
    # TODO: introduced 2025-10-25: remove after 26.05
    (lib.mkRenamedOptionModule
      [
        "plugins"
        "jupytext"
        "python3Dependencies"
      ]
      [ "extraPython3Packages" ]
    )
  ];
}
