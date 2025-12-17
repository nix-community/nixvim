{ lib, ... }:
let
  inherit (lib) types;
  inherit (import ./_helpers.nix lib) mkMappingsOption;
  mkExtension = import ./_mk-extension.nix;
  inherit (lib.nixvim) defaultNullOpts mkNullOrStr;
in
mkExtension {
  name = "file-browser";
  extensionName = "file_browser";
  package = "telescope-file-browser-nvim";

  settingsOptions = {
    theme = mkNullOrStr ''
      Custom theme, will use your global theme by default.
    '';

    path = defaultNullOpts.mkStr (lib.nixvim.literalLua "vim.uv.cwd()") ''
      Directory to browse files from.
      `vim.fn.expanded` automatically.
    '';

    cwd = defaultNullOpts.mkStr (lib.nixvim.literalLua "vim.uv.cwd()") ''
      Directory to browse folders from.
      `vim.fn.expanded` automatically.
    '';

    cwd_to_path = defaultNullOpts.mkBool false ''
      Whether folder browser is launched from `path` rather than `cwd`.
    '';

    grouped = defaultNullOpts.mkBool false ''
      Group initial sorting by directories and then files.
    '';

    files = defaultNullOpts.mkBool true ''
      Start in file (true) or folder (false) browser.
    '';

    add_dirs = defaultNullOpts.mkBool true ''
      Whether the file browser shows folders.
    '';

    depth = defaultNullOpts.mkUnsignedInt 1 ''
      File tree depth to display, `false` for unlimited depth.
    '';

    auto_depth = defaultNullOpts.mkBool false ''
      Unlimit or set `depth` to `auto_depth` & unset grouped on prompt for file_browser.
    '';

    select_buffer = defaultNullOpts.mkBool false ''
      Select current buffer if possible.
      May imply `hidden=true`.
    '';

    hidden =
      defaultNullOpts.mkNullable
        (
          with types;
          either bool (submodule {
            options = {
              file_browser = defaultNullOpts.mkBool false "";

              folder_browser = defaultNullOpts.mkBool false "";
            };
          })
        )
        {
          file_browser = false;
          folder_browser = false;
        }
        "Determines whether to show hidden files or not.";

    respect_gitignore = defaultNullOpts.mkBool false ''
      Induces slow-down w/ plenary finder (true if `fd` available).
    '';

    browse_files = defaultNullOpts.mkLuaFn "require('telescope._extensions.file_browser.finders').browse_files" "A custom lua function to override for the file browser.";

    browse_folders = defaultNullOpts.mkLuaFn "require('telescope._extensions.file_browser.finders').browse_folders" "A custom lua function to override for the folder browser.";

    hide_parent_dir = defaultNullOpts.mkBool false ''
      Hide `../` in the file browser.
    '';

    collapse_dirs = defaultNullOpts.mkBool false ''
      Skip with only a single (possibly hidden) sub-dir in file_browser.
    '';

    quiet = defaultNullOpts.mkBool false ''
      Suppress any notification from file_browser actions.
    '';

    dir_icon = defaultNullOpts.mkStr "" ''
      Change the icon for a directory.
    '';

    dir_icon_hl = defaultNullOpts.mkStr "Default" ''
      Change the highlight group of dir icon.
    '';

    display_stat = defaultNullOpts.mkAttrsOf types.anything {
      date = true;
      size = true;
      mode = true;
    } "Ordered stat; see upstream for more info.";

    hijack_netrw = defaultNullOpts.mkBool false ''
      Use telescope file browser when opening directory paths.
    '';

    use_fd = defaultNullOpts.mkBool true ''
      Use `fd` if available over `plenary.scandir`.
    '';

    git_status = defaultNullOpts.mkBool true ''
      Show the git status of files (true if `git` is found).
    '';

    prompt_path = defaultNullOpts.mkBool false ''
      Show the current relative path from cwd as the prompt prefix.
    '';

    mappings = mkMappingsOption {
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
