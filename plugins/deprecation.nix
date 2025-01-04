{ lib, ... }:
let
  deprecated = {
    # TODO: added 2024-10-23, move to removed after 24.11
    "rust-tools" = ''
      The `rust-tools` project has been abandoned.
      It is recommended to use `rustaceanvim` instead.
    '';
    # TODO: added 2025-01-04, move to removed after 25.11
    "project-nvim" = ''
      The project-nvim project has not been updated in 2 years
      and is broken on recent Neovim versions (it no longer adds projects
      automatically and provides no manual method to add them) use either
      telescope-project or projections-nvim.
    '';
  };
  removed = {
    # Added 2023-08-29
    treesitter-playground = ''
      The `treesitter-playground` plugin has been deprecated since the functionality is included in Neovim.
      Use:
      - `:Inspect` to show the highlight groups under the cursor
      - `:InspectTree` to show the parsed syntax tree ("TSPlayground")
      - `:PreviewQuery` to open the Query Editor (Nvim 0.10+)
    '';
  };
  renamed = {
    # Added 2024-09-17
    surround = "vim-surround";
  };
  # Added 2024-09-21; remove after 24.11
  # `iconsPackage` options were briefly available in the following plugins for ~3 weeks
  iconsPackagePlugins = [
    "telescope"
    "lspsaga"
    "nvim-tree"
    "neo-tree"
    "trouble"
    "alpha"
    "diffview"
    "fzf-lua"
    "bufferline"
    "barbar"
    "chadtree"
  ];
in
{

  imports =
    (lib.mapAttrsToList (
      name:
      lib.mkRemovedOptionModule [
        "plugins"
        name
      ]
    ) removed)
    ++ (lib.mapAttrsToList (
      old: new: lib.mkRenamedOptionModule [ "plugins" old ] [ "plugins" new ]
    ) renamed)
    ++ builtins.map (
      name:
      lib.mkRemovedOptionModule [ "plugins" name "iconsPackage" ] ''
        Please use `plugins.web-devicons` or `plugins.mini.modules.icons` with `plugins.mini.mockDevIcons` instead.
      ''
    ) iconsPackagePlugins
    ++ [
      (
        { config, options, ... }:
        {
          config = {
            warnings =
              lib.optionals (options.plugins.web-devicons.enable.highestPrio == 1490) [
                ''
                  Nixvim: `plugins.web-devicons` was enabled automatically because the following plugins are enabled.
                  This behaviour is deprecated. Please explicitly define `plugins.web-devicons.enable` or alternatively
                  enable `plugins.mini.enable` with `plugins.mini.modules.icons` and `plugins.mini.mockDevIcons`.
                  ${lib.concatMapStringsSep "\n" (name: "plugins.${name}") (
                    builtins.filter (name: config.plugins.${name}.enable) iconsPackagePlugins
                  )}
                ''
              ]
              ++ lib.foldlAttrs (
                warnings: plugin: msg:
                warnings
                ++ lib.optional config.plugins.${plugin}.enable ''
                  Nixvim Warning: The `${plugin}` plugin has been deprecated.
                  ${msg}
                ''
              ) [ ] deprecated;
          };
        }
      )
    ];
}
