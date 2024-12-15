{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "neocord";

  maintainers = [ ];

  settingsOptions = {
    # General options.
    auto_update = helpers.defaultNullOpts.mkBool true ''
      Update activity based on autocmd events.
      If `false`, map or manually execute
      `:lua package.loaded.neocord:update()`
    '';

    logo = helpers.defaultNullOpts.mkStr "auto" ''
      Update the Logo to the specified option ("auto" or url).
    '';

    logo_tooltip = helpers.mkNullOrStr ''
      Sets the logo tooltip
    '';

    main_image =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "language"
          "logo"
        ]
        ''
          Main image display (either "language" or "logo")
        '';

    client_id = helpers.defaultNullOpts.mkStr "1157438221865717891" ''
      Use your own Discord application client id. (not recommended)
    '';

    log_level =
      helpers.defaultNullOpts.mkEnum
        [
          "debug"
          "info"
          "warn"
          "error"
        ]
        null
        ''
          Log messages at or above this level.
        '';

    debounce_timeout = helpers.defaultNullOpts.mkInt 10 ''
      Number of seconds to debounce events.
      (or calls to `:lua package.loaded.neocord:update(<filename>, true)`)
    '';

    enable_line_number = helpers.defaultNullOpts.mkBool false ''
      Displays the current line number instead of the current project.
    '';

    blacklist = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      A list of strings or Lua patterns that disable Rich Presence if the
      current file name, path, or workspace matches.
    '';

    buttons =
      helpers.defaultNullOpts.mkListOf
        (
          with types;
          submodule {
            options = {
              label = helpers.mkNullOrStr "";
              url = helpers.mkNullOrStr "";
            };
          }
        )
        [ ]
        ''
          Button configurations which will always appear in Rich Presence.
          Can be a list of attribute sets, each with the following attributes:
          `label`: The label of the button. e.g. `"GitHub Profile"`.
          `url`: The URL the button leads to. e.g. `"https://github.com/<NAME>"`.
          Can also be a lua function: `function(buffer: string, repo_url: string|nil): table`
        '';

    file_assets = helpers.mkNullOrOption (with types; attrsOf (listOf str)) ''
      Custom file asset definitions keyed by file names and extensions.
      List elements for each attribute (filetype):
      `name`: The name of the asset shown as the title of the file in Discord.
      `source`: The source of the asset, either an art asset key or the URL of an image asset.
      Example:
      ```nix
        {
          # Use art assets uploaded in Discord application for the configured client id
          js = [ "JavaScript" "javascript" ];
          ts = [ "TypeScript" "typescript" ];
          # Use image URLs
          rs = [ "Rust" "https://www.rust-lang.org/logos/rust-logo-512x512.png" ];
          go = [ "Go" "https://go.dev/blog/go-brand/Go-Logo/PNG/Go-Logo_Aqua.png" ];
        };
      ```
    '';

    show_time = helpers.defaultNullOpts.mkBool true "Show the timer.";

    global_timer = helpers.defaultNullOpts.mkBool false "if set true, timer won't update when any event are triggered.";

    # Rich presence text options.
    editing_text = helpers.defaultNullOpts.mkStr "Editing %s" ''
      String rendered when an editable file is loaded in the buffer.
      Can also be a lua function:
      `function(filename: string): string`
    '';

    file_explorer_text = helpers.defaultNullOpts.mkStr "Browsing %s" ''
      String rendered when browsing a file explorer.
      Can also be a lua function:
      `function(file_explorer_name: string): string`
    '';

    git_commit_text = helpers.defaultNullOpts.mkStr "Committing changes" ''
      String rendered when committing changes in git.
      Can also be a lua function:
      `function(filename: string): string`
    '';

    plugin_manager_text = helpers.defaultNullOpts.mkStr "Managing plugins" ''
      String rendered when managing plugins.
      Can also be a lua function:
      `function(plugin_manager_name: string): string`
    '';

    reading_text = helpers.defaultNullOpts.mkStr "Reading %s" ''
      String rendered when a read-only/unmodifiable file is loaded into the buffer.
      Can also be a lua function:
      `function(filename: string): string`
    '';

    workspace_text = helpers.defaultNullOpts.mkStr "Working on %s" ''
      String rendered when in a git repository.
      Can also be a lua function:
      `function(project_name: string|nil, filename: string): string`
    '';

    line_number_text = helpers.defaultNullOpts.mkStr "Line %s out of %s" ''
      String rendered when `enableLineNumber` is set to `true` to display the current line number.
      Can also be a lua function:
      `function(line_number: number, line_count: number): string`
    '';

    terminal_text = helpers.defaultNullOpts.mkStr "Using Terminal" ''
      Format string rendered when in terminal mode.
    '';
  };

  settingsExample = {
    #General options
    auto_update = true;
    logo = "auto";
    logo_tooltip = null;
    main_image = "language";
    client_id = "1157438221865717891";
    log_level = null;
    debounce_timeout = 10;
    enable_line_number = false;
    blacklist = [ ];
    file_assets = null;
    show_time = true;
    global_timer = false;

    # Rich Presence text options
    editing_text = "Editing...";
    file_explorer_text = "Browsing...";
    git_commit_text = "Committing changes...";
    plugin_manager_text = "Managing plugins...";
    reading_text = "Reading...";
    workspace_text = "Working on %s";
    line_number_text = "Line %s out of %s";
    terminal_text = "Using Terminal...";
  };
}
