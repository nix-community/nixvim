{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.telescope.extensions.file_browser;
  helpers = import ../helpers.nix {inherit lib;};

  hiddenOption = types.submodule {
    options = {
      fileBrowser = helpers.mkNullOrOption types.bool "";

      folderBrowser = helpers.mkNullOrOption types.bool "";
    };
  };

  statOption = types.submodule {
    options = {
      width = helpers.mkNullOrOption types.int "";
      display = helpers.mkNullOrOption types.str "";
      hl = helpers.mkNullOrOption types.str "";
    };
  };
in {
  options.plugins.telescope.extensions.file_browser = {
    enable = mkEnableOption "file browser extension for telescope";

    package = helpers.mkPackageOption "telescope file_browser" pkgs.vimPlugins.telescope-file-browser-nvim;

    theme = helpers.mkNullOrOption types.str "Custom theme, will use your global theme by default.";

    path = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.rawType) "vim.loop.cwd()" ''
      Directory to browse files from.
      `vim.fn.expanded` automatically.
    '';

    cwd = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.rawType) "vim.loop.cwd()" ''
      Directory to browse folders from.
      `vim.fn.expanded` automatically.
    '';

    cwdToPath = helpers.defaultNullOpts.mkBool false ''
      Whether folder browser is launched from `path` rather than `cwd`.
    '';

    grouped = helpers.defaultNullOpts.mkBool false ''
      Group initial sorting by directories and then files.
    '';

    files = helpers.defaultNullOpts.mkBool true ''
      Start in file (true) or folder (false) browser.
    '';

    addDirs = helpers.defaultNullOpts.mkBool true ''
      Whether the file browser shows folders.
    '';

    depth = helpers.defaultNullOpts.mkInt 1 ''
      File tree depth to display, `false` for unlimited depth.
    '';

    autoDepth = helpers.defaultNullOpts.mkBool false ''
      Unlimit or set `depth` to `auto_depth` & unset grouped on prompt for file_browser.
    '';

    selectBuffer = helpers.defaultNullOpts.mkBool false ''
      Select current buffer if possible.
      May imply `hidden=true`.
    '';

    hidden = helpers.defaultNullOpts.mkNullable (types.either types.bool hiddenOption) "false" ''
      Determines whether to show hidden files or not.
    '';

    respectGitignore = helpers.defaultNullOpts.mkBool false ''
      Induces slow-down w/ plenary finder (true if `fd` available).
    '';

    browseFiles = helpers.defaultNullOpts.mkStr "fb_finders.browse_files" ''
      A custom lua function to override for the file browser.
    '';

    browseFolders = helpers.defaultNullOpts.mkStr "fb_finders.browse_folders" ''
      A custom lua function to override for the folder browser.
    '';

    hideParentDir = helpers.defaultNullOpts.mkBool false ''
      Hide `../` in the file browser.
    '';

    collapseDirs = helpers.defaultNullOpts.mkBool false ''
      Skip with only a single (possibly hidden) sub-dir in file_browser.
    '';

    quiet = helpers.defaultNullOpts.mkBool false ''
      Surpress any notification from file_brower actions.
    '';

    dirIcon = helpers.defaultNullOpts.mkStr "" ''
      Change the icon for a directory.
    '';

    dirIconHl = helpers.defaultNullOpts.mkStr "Default" ''
      Change the highlight group of dir icon.
    '';

    displayStat =
      helpers.defaultNullOpts.mkNullable (with types; attrsOf (either bool statOption))
      "{ date = true, size = true, mode = true }" ''
        Ordered stat; see upstream for more info.
      '';

    hijackNetrw = helpers.defaultNullOpts.mkBool false ''
      Use telescope file browser when opening directory paths.
    '';

    useFd = helpers.defaultNullOpts.mkBool true ''
      Use `fd` if available over `plenary.scandir`.
    '';

    gitStatus = helpers.defaultNullOpts.mkBool true ''
      Show the git status of files (true if `git` is found).
    '';

    promptPath = helpers.defaultNullOpts.mkBool false ''
      Show the current relative path from cwd as the prompt prefix.
    '';

    mappings =
      helpers.mkNullOrOption (
        with types;
          attrsOf (attrsOf (either str helpers.rawType))
      ) ''
        `fb_actions` mappings.
        Mappings can also be a lua function.
      '';
  };

  config = let
    options = with cfg; {
      inherit
        depth
        cwd
        files
        grouped
        path
        quiet
        theme
        ;
      add_dirs = addDirs;
      auto_depth = autoDepth;
      browse_files =
        helpers.ifNonNull' browseFiles
        (helpers.mkRaw browseFiles);
      browse_folders =
        helpers.ifNonNull' browseFolders
        (helpers.mkRaw browseFolders);
      collapse_dirs = collapseDirs;
      cwd_to_path = cwdToPath;
      dir_icon = dirIcon;
      dir_icon_hl = dirIconHl;
      display_stat =
        helpers.ifNonNull' displayStat
        (
          with builtins;
            mapAttrs (
              _: attr:
                if isBool attr
                then attr
                else
                  attr
                  // {
                    display = helpers.ifNonNull' attr.display (helpers.mkRaw attr.display);
                  }
            )
            displayStat
        );

      git_status = gitStatus;
      hidden = helpers.ifNonNull' hidden (
        if isBool hidden
        then hidden
        else
          with hidden; {
            file_browser = fileBrowser;
            folder_browser = folderBrowser;
          }
      );
      hide_parent_dir = hideParentDir;
      hijack_netrw = hijackNetrw;
      mappings = helpers.ifNonNull' mappings (
        with builtins;
          mapAttrs (
            _:
              mapAttrs (
                _: action:
                  if isString action
                  then helpers.mkRaw "require('telescope._extensions.file_browser.actions').${action}"
                  else action
              )
          )
          mappings
      );
      prompt_path = promptPath;
      respect_gitignore = respectGitignore;
      select_buffer = selectBuffer;
      use_fd = useFd;
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      plugins.telescope = {
        enabledExtensions = ["file_browser"];
        extensionConfig."file_browser" = options;
      };
    };
}
