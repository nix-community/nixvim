{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.presence-nvim;
  helpers = import ../helpers.nix {inherit lib;};

  # Given an attribute with the child attributes of:
  # - Some static attribute
  # - Some attriubte which represents a lua function as a string
  # This function will prioritize choosing the static attribute, then will
  # fall back to the raw lua function.
  staticOrFunc = attribute: static_name:
    helpers.ifNonNull' attribute (
      if attribute.${static_name} != null
      then attribute.${static_name}
      else helpers.mkRaw attribute.function
    );
in {
  options = {
    plugins.presence-nvim =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "Enable presence-nvim.";
        package = helpers.mkPackageOption "presence-nvim" pkgs.vimPlugins.presence-nvim;

        # General options.
        autoUpdate = helpers.defaultNullOpts.mkBool true ''
          Update activity based on autocmd events.
          If `false`, map or manually execute
          `:lua package.loaded.presence:update()`
        '';

        neovimImageText = helpers.defaultNullOpts.mkStr ''"The One True Text Editor"'' ''
          Text displayed when hovered over the Neovim image.
        '';

        mainImage = helpers.defaultNullOpts.mkStr ''"neovim"'' ''
          Main image display. (either `"neovim"` or `"file"`).
        '';

        clientId = helpers.defaultNullOpts.mkStr ''"793271441293967371"'' ''
          Use your own Discord application client id. (not recommended)
        '';

        logLevel = helpers.mkNullOrOption types.str ''
          Log messages at or above this level.
          One of the following: `"debug"`, `"info"`, `"warn"`, `"error"`
        '';

        debounceTimeout = helpers.defaultNullOpts.mkInt 10 ''
          Number of seconds to debounce events.
          (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
        '';

        enableLineNumber = helpers.defaultNullOpts.mkBool false ''
          Displays the current line number instead of the current project.
        '';

        blacklist = helpers.mkNullOrOption (types.listOf types.str) ''
          A list of strings or Lua patterns that disable Rich Presence if the
          current file name, path, or workspace matches.
        '';

        buttons = helpers.mkCompositeOption "Configure Rich Presence button(s)." {
          function = helpers.mkNullOrOption types.str ''
            A lua function: `function(buffer: string, repo_url: string|nil): table)`.

            NOTE: Any modifications to `plugins.presence-nvim.buttons.static`
            will take precedence over this.
          '';
          static =
            helpers.mkNullOrOption
            (types.listOf (types.submodule {
              options = {
                label = helpers.mkNullOrOption types.str ''
                  The label of the button.

                  Example: `"Github Profile";`
                '';

                url = helpers.mkNullOrOption types.str ''
                  The URL the button leads to.

                  Example: `"https://github.com/<NAME>";`
                '';
              };
            }))
            ''
              Static button configurations that will always appear in Rich Presence.

              Example:
              ```
              [
                { label = "GitHub Profile"; url = "https://github.com/<NAME>"; }
                { label = "Check out my dotfiles"; url = "https://github.com/<NAME>/dotfiles"; }
              ];
              ```
            '';
        };

        fileAssets = helpers.mkNullOrOption (with types; attrsOf (listOf str)) ''
          Custom file asset definitions keyed by file names and extensions.

          List elements for each attribute (filetype):

          `name`: The name of the asset shown as the title of the file in Discord.

          `source`: The source of the asset, either an art asset key or the URL of an image asset.

          Example:
          ```
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

        # Rich presence text options.

        editing =
          helpers.mkCompositeOption
          ''
            String rendered when an editable file is loaded in the buffer.
          ''
          {
            text = helpers.defaultNullOpts.mkStr ''"Editing %s"'' ''
              Format string to render.
            '';

            function = helpers.mkNullOrOption types.str ''
              Lua function to render from. `function(filename: string): string`.

              NOTE: Any modifications to `plugins.presence-nvim.editing.text`
              will take precedence over this.
            '';
          };

        fileExplorer =
          helpers.mkCompositeOption
          ''
            String rendered when browsing a file explorer.
          ''
          {
            text = helpers.defaultNullOpts.mkStr ''"Browsing %s"'' ''
              Format string to render.
            '';

            function = helpers.mkNullOrOption types.str ''
              Lua function to render from. `function(file_explorer_name: string): string`.

              NOTE: Any modifications to `plugins.presence-nvim.fileExplorer.text`
              will take precedence over this.
            '';
          };

        gitCommit =
          helpers.mkCompositeOption
          ''
            String rendered when committing changes in git.
          ''
          {
            text = helpers.defaultNullOpts.mkStr ''"Committing changes"'' ''
              Format string to render.
            '';

            function = helpers.mkNullOrOption types.str ''
              Lua function to render from. `function(filename: string): string`.

              NOTE: Any modifications to `plugins.presence-nvim.gitCommit.text`
              will take precedence over this.
            '';
          };

        pluginManager =
          helpers.mkCompositeOption
          ''
            String rendered when managing plugins.
          ''
          {
            text = helpers.defaultNullOpts.mkStr ''"Managing plugins"'' ''
              Format string to render.
            '';

            function = helpers.mkNullOrOption types.str ''
              Lua function to render from. `function(plugin_manager_name: string): string`.

              NOTE: Any modifications to `plugins.presence-nvim.pluginManager.text`
              will take precedence over this.
            '';
          };

        reading =
          helpers.mkCompositeOption
          ''
            String rendered when a read-only/unmodifiable file is loaded into the buffer.
          ''
          {
            text = helpers.defaultNullOpts.mkStr ''"Reading %s"'' ''
              Format string to render.
            '';

            function = helpers.mkNullOrOption types.str ''
              Lua function to render from. `function(filename: string): string`.

              NOTE: Any modifications to `plugins.presence-nvim.reading.text`
              will take precedence over this.
            '';
          };

        workspace =
          helpers.mkCompositeOption
          ''
            String rendered when in a git repository.
          ''
          {
            text = helpers.defaultNullOpts.mkStr ''"Working on %s"'' ''
              Format string to render.
            '';

            function = helpers.mkNullOrOption types.str ''
              Lua function to render from. `function(project_name: string|nil, filename: string): string`.

              NOTE: Any modifications to `plugins.presence-nvim.workspace.text`
              will take precedence over this.
            '';
          };

        lineNumber =
          helpers.mkCompositeOption
          ''
            String rendered when `enableLineNumber` is set to `true` to display the current line number.
          ''
          {
            text = helpers.defaultNullOpts.mkStr ''"Line %s out of %s"'' ''
              Format string to render.
            '';

            function = helpers.mkNullOrOption types.str ''
              Lua function to render from. `function(line_number: number, line_count: number): string`.

              NOTE: Any modifications to `plugins.presence-nvim.lineNumber.text`
              will take precedence over this.
            '';
          };
      };
  };

  config = let
    setupOptions =
      {
        auto_update = cfg.autoUpdate;
        neovim_image_text = cfg.neovimImageText;
        main_image = cfg.mainImage;
        client_id = cfg.clientId;
        log_level = cfg.logLevel;
        debounce_timeout = cfg.debounceTimeout;
        enable_line_number = cfg.enableLineNumber;
        blacklist = cfg.blacklist;
        file_assets = cfg.fileAssets;
        show_time = cfg.showTime;

        buttons = staticOrFunc cfg.buttons "static";

        editing_text = staticOrFunc cfg.editing "text";
        file_explorer_text = staticOrFunc cfg.fileExplorer "text";
        git_commit_text = staticOrFunc cfg.gitCommit "text";
        plugin_manager_text = staticOrFunc cfg.pluginManager "text";
        reading_text = staticOrFunc cfg.reading "text";
        workspace_text = staticOrFunc cfg.workspace "text";
        line_number_text = staticOrFunc cfg.lineNumber "text";
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        require("presence").setup${helpers.toLuaObject setupOptions}
      '';
    };
}
