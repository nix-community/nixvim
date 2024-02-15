{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.neocord;
in {
  options = {
    plugins.neocord = {
      enable = mkEnableOption "neocord";
      package = helpers.mkPackageOption "neocord" pkgs.vimPlugins.neocord;

      # General options.
      autoUpdate = helpers.defaultNullOpts.mkBool true ''
        Update activity based on autocmd events.
        If `false`, map or manually execute
        `:lua package.loaded.neocord:update()`
      '';

      logo = helpers.defaultNullOpts.mkEnum ["auto" "url"] "auto" ''
        Update the Logo to the specified option ("auto" or url).
      '';

      logoTooltip = helpers.defaultNullOpts.mkEnum ["null" "string"] "null" ''
        Sets the logo tooltip
      '';

      mainImage = helpers.defaultNullOpts.mkEnum ["language" "logo"] "language" ''
        Main image display (either "language" or "logo")
      '';

      clientId = helpers.defaultNullOpts.mkStr "1157438221865717891" ''
        Use your own Discord application client id. (not recommended)
      '';

      logLevel = helpers.defaultNullOpts.mkEnum ["debug" "info" "warn" "error"] "null" ''
        Log messages at or above this level.
      '';

      debounceTimeout = helpers.defaultNullOpts.mkInt 10 ''
        Number of seconds to debounce events.
        (or calls to `:lua package.loaded.neocord:update(<filename>, true)`)
      '';

      enableLineNumber = helpers.defaultNullOpts.mkBool false ''
        Displays the current line number instead of the current project.
      '';

      blacklist = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
        A list of strings or Lua patterns that disable Rich Presence if the
        current file name, path, or workspace matches.
      '';

      buttons =
        helpers.defaultNullOpts.mkNullable
        (types.either helpers.nixvimTypes.rawLua
          (types.listOf (types.submodule {
            options = {
              label = helpers.mkNullOrOption types.str "";
              url = helpers.mkNullOrOption types.str "";
            };
          })))
        "[]"
        ''
          Button configurations which will always appear in Rich Presence.

          Can be a list of attribute sets, each with the following attributes:

          `label`: The label of the button. e.g. `"GitHub Profile"`.

          `url`: The URL the button leads to. e.g. `"https://github.com/<NAME>"`.

          Can also be a lua function: `function(buffer: string, repo_url: string|nil): table`
        '';

      fileAssets = helpers.mkNullOrOption (with types; attrsOf (listOf str)) ''
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

      showTime = helpers.defaultNullOpts.mkBool true "Show the timer.";

      globalTimer = helpers.defaultNullOpts.mkBool false "if set true, timer won't update when any event are triggered.";

      # Rich presence text options.
      editingText = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua) "Editing %s" ''
        String rendered when an editable file is loaded in the buffer.

        Can also be a lua function:
        `function(filename: string): string`
      '';

      fileExplorerText = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua) "Browsing %s" ''
        String rendered when browsing a file explorer.

        Can also be a lua function:
        `function(file_explorer_name: string): string`
      '';

      gitCommitText = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua) "Committing changes" ''
        String rendered when committing changes in git.

        Can also be a lua function:
        `function(filename: string): string`
      '';

      pluginManagerText = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua) "Managing plugins" ''
        String rendered when managing plugins.

        Can also be a lua function:
        `function(plugin_manager_name: string): string`
      '';

      readingText = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua) "Reading %s" ''
        String rendered when a read-only/unmodifiable file is loaded into the buffer.

        Can also be a lua function:
        `function(filename: string): string`
      '';

      workspaceText = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua) "Working on %s" ''
        String rendered when in a git repository.

        Can also be a lua function:
        `function(project_name: string|nil, filename: string): string`
      '';

      lineNumberText = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua) "Line %s out of %s" ''
        String rendered when `enableLineNumber` is set to `true` to display the current line number.

        Can also be a lua function:
        `function(line_number: number, line_count: number): string`
      '';

      terminalText = helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua) "Using Terminal" ''
        Format string rendered when in terminal mode.
      '';
    };
  };

  config = let
    setupOptions =
      {
        # General options.
        auto_update = cfg.autoUpdate;
        inherit (cfg) logo;
        inherit (cfg) logo_tooltip;
        main_image = cfg.mainImage;
        client_id = cfg.clientId;
        log_level = cfg.logLevel;
        debounce_timeout = cfg.debounceTimeout;
        enable_line_number = cfg.enableLineNumber;
        inherit (cfg) blacklist;
        inherit (cfg) buttons;
        file_assets = cfg.fileAssets;
        show_time = cfg.showTime;
        global_timer = cfg.globalTimer;

        # Rich presence text options.
        editing_text = cfg.editingText;
        file_explorer_text = cfg.fileExplorerText;
        git_commit_text = cfg.gitCommitText;
        plugin_manager_text = cfg.pluginManagerText;
        reading_text = cfg.readingText;
        workspace_text = cfg.workspaceText;
        line_number_text = cfg.lineNumberText;
        terminal_text = cfg.terminalText;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [
        cfg.package
      ];
      extraConfigLua = ''
        require("neocord").setup${helpers.toLuaObject setupOptions}
      '';
    };
}
