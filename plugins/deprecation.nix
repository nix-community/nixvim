{ lib, ... }:
let
  deprecated = {
    # Added 2025-10-22
    tailwind-tools = ''
      The upstream GitHub project for tailwind-tools is archived, and enabling this plugin triggers an lspconfig deprecation warning.
      Consider disabling it or switching to an alternative.
    '';
  };
  removed.plugins = {
    # Added 2023-08-29
    treesitter-playground = ''
      The `treesitter-playground` plugin has been deprecated since the functionality is included in Neovim.
      Use:
      - `:Inspect` to show the highlight groups under the cursor
      - `:InspectTree` to show the parsed syntax tree ("TSPlayground")
      - `:PreviewQuery` to open the Query Editor (Nvim 0.10+)
    '';

    # Added 2025-03-30
    packer = ''
      The `packer` plugin manager has been unmaintained for several years.
      It is recommended to use `plugins.pckr` or `plugins.lazy` instead.
    '';

    # Added 2025-10-06
    rust-tools = ''
      The `rust-tools` project has been abandoned.
      It is recommended to use `rustaceanvim` instead.
    '';

    # Added 2025-10-14
    nvim-osc52 = ''
      The `nvim-osc52` plugin is obsolete.
      As of Neovim 0.10, native support for OSC52 has been added.
      See `:h clipboard-osc52` for more details: https://neovim.io/doc/user/provider.html#clipboard-osc52
    '';
  };
  renamed.plugins = {
    # Added 2024-09-17
    surround = "vim-surround";
    # Added 2025-10-06
    presence-nvim = "presence";
    # Added 2025-11-07
    ethersync = "teamtype";
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
    # TODO: introduced 2025-04-19
    [
      (lib.mkRenamedOptionModule
        [ "plugins" "codeium-nvim" "enable" ]
        [ "plugins" "windsurf-nvim" "enable" ]
      )
      (lib.mkRenamedOptionModule
        [ "plugins" "codeium-vim" "enable" ]
        [ "plugins" "windsurf-vim" "enable" ]
      )
    ]
    ++ lib.foldlAttrs (
      acc: scope: removed':
      acc ++ lib.mapAttrsToList (name: msg: lib.mkRemovedOptionModule [ scope name ] msg) removed'
    ) [ ] removed
    ++ lib.foldlAttrs (
      acc: scope: renamed':
      acc ++ lib.mapAttrsToList (old: new: lib.mkRenamedOptionModule [ scope old ] [ scope new ]) renamed'
    ) [ ] renamed
    ++ builtins.map (
      name:
      lib.mkRemovedOptionModule [ "plugins" name "iconsPackage" ] ''
        Please use `plugins.web-devicons` or `plugins.mini.modules.icons` with `plugins.mini.mockDevIcons`, or `plugins.mini-icons` with `plugins.mini-icons.mockDevIcons` instead.
      ''
    ) iconsPackagePlugins
    ++ [
      (
        { config, options, ... }:
        {
          config = {
            warnings =
              (lib.nixvim.mkWarnings "plugins.web-devicons" {
                when = options.plugins.web-devicons.enable.highestPrio == 1490;

                message = ''
                  This plugin was enabled automatically because the following plugins are enabled.
                  This behaviour is deprecated. Please explicitly define `plugins.web-devicons.enable` or alternatively
                  enable `plugins.mini.enable` with `plugins.mini.modules.icons` and `plugins.mini.mockDevIcons`, or
                  `plugins.mini-icons.enable` with `plugins.mini-icons.mockDevIcons`.
                  ${lib.concatMapStringsSep "\n" (name: "plugins.${name}") (
                    builtins.filter (name: config.plugins.${name}.enable) iconsPackagePlugins
                  )}
                '';
              })
              ++ lib.foldlAttrs (
                warnings: plugin: msg:
                warnings
                ++ (lib.nixvim.mkWarnings "plugins.${plugin}" {
                  when = config.plugins.${plugin}.enable;
                  message = ''
                    This plugin has been deprecated.
                    ${msg}
                  '';
                })
              ) [ ] deprecated;
          };
        }
      )
    ];
}
