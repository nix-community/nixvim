{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  telescopeHelpers = import ./_helpers.nix {
    inherit
      lib
      helpers
      config
      pkgs
      ;
  };
in
telescopeHelpers.mkExtension {
  name = "file-browser";
  extensionName = "file_browser";
  defaultPackage = pkgs.vimPlugins.telescope-file-browser-nvim;

  # TODO: introduced 2024-03-24, remove on 2024-05-24
  optionsRenamedToSettings = [
    "theme"
    "path"
    "cwd"
    "cwdToPath"
    "grouped"
    # "files"  TODO this warning is causing an 'infinite recursion error'... No idea why
    "addDirs"
    "depth"
    "autoDepth"
    "selectBuffer"
    "hidden"
    "respectGitignore"
    "browseFiles"
    "browseFolders"
    "hideParentDir"
    "collapseDirs"
    "quiet"
    "dirIcon"
    "dirIconHl"
    "displayStat"
    "hijackNetrw"
    "useFd"
    "gitStatus"
    "promptPath"
  ];
  imports = [
    (mkRemovedOptionModule
      [
        "plugins"
        "telescope"
        "extensions"
        "file-browser"
        "mappings"
      ]
      ''
        Use `plugins.telescope.extension.file-browser.settings.mappings` instead but beware, you need to specify the full name of the callback:
        Example:
        ```
          mappings = {
            i = {
              "<A-c>" = "require('telescope._extensions.file_browser.actions').create";
              "<S-CR>" = "require('telescope._extensions.file_browser.actions').create_from_prompt";
              "<A-r>" = "require('telescope._extensions.file_browser.actions').rename";
            };
            n = {
              "c" = "require('telescope._extensions.file_browser.actions').create";
              "r" = "require('telescope._extensions.file_browser.actions').rename";
              "m" = "require('telescope._extensions.file_browser.actions').move";
            };
          }
        ```
      ''
    )
  ];

  settingsOptions = {
    theme = helpers.mkNullOrStr ''
      Custom theme, will use your global theme by default.
    '';

    path = helpers.defaultNullOpts.mkStr { __raw = "vim.loop.cwd()"; } ''
      Directory to browse files from.
      `vim.fn.expanded` automatically.
    '';

    cwd = helpers.defaultNullOpts.mkStr { __raw = "vim.loop.cwd()"; } ''
      Directory to browse folders from.
      `vim.fn.expanded` automatically.
    '';

    cwd_to_path = helpers.defaultNullOpts.mkBool false ''
      Whether folder browser is launched from `path` rather than `cwd`.
    '';

    grouped = helpers.defaultNullOpts.mkBool false ''
      Group initial sorting by directories and then files.
    '';

    files = helpers.defaultNullOpts.mkBool true ''
      Start in file (true) or folder (false) browser.
    '';

    add_dirs = helpers.defaultNullOpts.mkBool true ''
      Whether the file browser shows folders.
    '';

    depth = helpers.defaultNullOpts.mkUnsignedInt 1 ''
      File tree depth to display, `false` for unlimited depth.
    '';

    auto_depth = helpers.defaultNullOpts.mkBool false ''
      Unlimit or set `depth` to `auto_depth` & unset grouped on prompt for file_browser.
    '';

    select_buffer = helpers.defaultNullOpts.mkBool false ''
      Select current buffer if possible.
      May imply `hidden=true`.
    '';

    hidden =
      helpers.defaultNullOpts.mkNullable
        (
          with types;
          either bool (submodule {
            options = {
              file_browser = helpers.defaultNullOpts.mkBool false "";

              folder_browser = helpers.defaultNullOpts.mkBool false "";
            };
          })
        )
        {
          file_browser = false;
          folder_browser = false;
        }
        "Determines whether to show hidden files or not.";

    respect_gitignore = helpers.defaultNullOpts.mkBool false ''
      Induces slow-down w/ plenary finder (true if `fd` available).
    '';

    browse_files = helpers.defaultNullOpts.mkLuaFn "require('telescope._extensions.file_browser.finders').browse_files" "A custom lua function to override for the file browser.";

    browse_folders = helpers.defaultNullOpts.mkLuaFn "require('telescope._extensions.file_browser.finders').browse_folders" "A custom lua function to override for the folder browser.";

    hide_parent_dir = helpers.defaultNullOpts.mkBool false ''
      Hide `../` in the file browser.
    '';

    collapse_dirs = helpers.defaultNullOpts.mkBool false ''
      Skip with only a single (possibly hidden) sub-dir in file_browser.
    '';

    quiet = helpers.defaultNullOpts.mkBool false ''
      Suppress any notification from file_browser actions.
    '';

    dir_icon = helpers.defaultNullOpts.mkStr "" ''
      Change the icon for a directory.
    '';

    dir_icon_hl = helpers.defaultNullOpts.mkStr "Default" ''
      Change the highlight group of dir icon.
    '';

    display_stat = helpers.defaultNullOpts.mkAttrsOf types.anything {
      date = true;
      size = true;
      mode = true;
    } "Ordered stat; see upstream for more info.";

    hijack_netrw = helpers.defaultNullOpts.mkBool false ''
      Use telescope file browser when opening directory paths.
    '';

    use_fd = helpers.defaultNullOpts.mkBool true ''
      Use `fd` if available over `plenary.scandir`.
    '';

    git_status = helpers.defaultNullOpts.mkBool true ''
      Show the git status of files (true if `git` is found).
    '';

    prompt_path = helpers.defaultNullOpts.mkBool false ''
      Show the current relative path from cwd as the prompt prefix.
    '';

    mappings = telescopeHelpers.mkMappingsOption {
      insertDefaults = ''
        {
          "<A-c>" = "require('telescope._extensions.file_browser.actions').create";
          "<S-CR>" = "require('telescope._extensions.file_browser.actions').create_from_prompt";
          "<A-r>" = "require('telescope._extensions.file_browser.actions').rename";
          "<A-m>" = "require('telescope._extensions.file_browser.actions').move";
          "<A-y>" = "require('telescope._extensions.file_browser.actions').copy";
          "<A-d>" = "require('telescope._extensions.file_browser.actions').remove";
          "<C-o>" = "require('telescope._extensions.file_browser.actions').open";
          "<C-g>" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
          "<C-e>" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
          "<C-w>" = "require('telescope._extensions.file_browser.actions').goto_cwd";
          "<C-t>" = "require('telescope._extensions.file_browser.actions').change_cwd";
          "<C-f>" = "require('telescope._extensions.file_browser.actions').toggle_browser";
          "<C-h>" = "require('telescope._extensions.file_browser.actions').toggle_hidden";
          "<C-s>" = "require('telescope._extensions.file_browser.actions').toggle_all";
          "<bs>" = "require('telescope._extensions.file_browser.actions').backspace";
        }
      '';

      normalDefaults = ''
        {
          "c" = "require('telescope._extensions.file_browser.actions').create";
          "r" = "require('telescope._extensions.file_browser.actions').rename";
          "m" = "require('telescope._extensions.file_browser.actions').move";
          "y" = "require('telescope._extensions.file_browser.actions').copy";
          "d" = "require('telescope._extensions.file_browser.actions').remove";
          "o" = "require('telescope._extensions.file_browser.actions').open";
          "g" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
          "e" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
          "w" = "require('telescope._extensions.file_browser.actions').goto_cwd";
          "t" = "require('telescope._extensions.file_browser.actions').change_cwd";
          "f" = "require('telescope._extensions.file_browser.actions').toggle_browser";
          "h" = "require('telescope._extensions.file_browser.actions').toggle_hidden";
          "s" = "require('telescope._extensions.file_browser.actions').toggle_all";
        }
      '';
    };
  };

  settingsExample = {
    file_browser = {
      theme = "ivy";
      hijack_netrw = true;
    };
  };
}
