{ lib, ... }:
let
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
      old: new:
      lib.mkRenamedOptionModule
        [
          "plugins"
          old
        ]
        [
          "plugins"
          new
        ]
    ) renamed)
    ++ builtins.map (
      name:
      lib.mkRemovedOptionModule
        [
          "plugins"
          name
          "iconsPackage"
        ]
        ''
          Please use `plugins.web-devicons` or `plugins.mini.modules.icons` with `plugins.mini.mockDevIcons` instead.
        ''
    ) iconsPackagePlugins
    # Show a warning when web-devicons is auto-enabled
    ++ [
      (
        { config, options, ... }:
        {
          config = lib.mkIf (options.plugins.web-devicons.enable.highestPrio == 1490) {
            warnings = [
              ''
                Nixvim: `plugins.web-devicons` was enabled automatically because the following plugins are enabled.
                This behaviour is deprecated. Please explicitly define `plugins.web-devicons.enable` or alternatively enable `plugins.mini.modules.icons` with `plugins.mini.mockDevIcons`.
                ${lib.concatMapStringsSep "\n" (name: "plugins.${name}") (
                  builtins.filter (name: config.plugins.${name}.enable) iconsPackagePlugins
                )}
              ''
            ];
          };
        }
      )
    ];
}
