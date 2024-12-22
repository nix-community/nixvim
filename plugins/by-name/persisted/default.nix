{
  lib,
  config,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "persisted";
  packPathName = "persisted.nvim";
  package = "persisted-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    enableTelescope = lib.mkEnableOption "persisted-nvim telescope integration";
  };

  extraConfig = cfg: {
    warnings = lib.optional (cfg.enableTelescope && (!config.plugins.telescope.enable)) ''
      Telescope support for `plugins.persisted` is enabled but the telescope plugin is not.
    '';

    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "persisted" ];
  };

  settingsOptions = {
    autostart = defaultNullOpts.mkBool true ''
      Whether to automatically start the plugin on load.
    '';

    should_save =
      defaultNullOpts.mkRaw
        ''
          function()
            return true
          end
        ''
        ''
          Function to determine if a session should be saved.

          ```lua
          @type fun(): boolean
          ```
        '';

    save_dir = defaultNullOpts.mkStr (lib.nixvim.literalLua "vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/')") ''
      Directory where session files are saved.
    '';

    follow_cwd = defaultNullOpts.mkBool true ''
      Whether to change the session file to match any change in the cwd.
    '';

    use_git_branch = defaultNullOpts.mkBool false ''
      Whether to include the git branch in the session file name.
    '';

    autoload = defaultNullOpts.mkBool false ''
      Whether to automatically load the session for the cwd on Neovim startup.
    '';

    on_autoload_no_session = defaultNullOpts.mkRaw "function() end" ''

      Function to run when `autoload = true` but there is no session to load.

      ```lua
      @type fun(): any
      ```
    '';

    allowed_dirs = defaultNullOpts.mkListOf types.str [ ] ''
      List of dirs that the plugin will start and autoload from.
    '';

    ignored_dirs = defaultNullOpts.mkListOf types.str [ ] ''
      List of dirs that are ignored for starting and autoloading.
    '';

    telescope = {
      mappings =
        defaultNullOpts.mkAttrsOf types.str
          {
            copy_session = "<C-c>";
            change_branch = "<C-b>";
            delete_session = "<C-d>";
          }
          ''
            Mappings for managing sessions in Telescope.
          '';

      icons =
        defaultNullOpts.mkAttrsOf types.str
          {
            selected = " ";
            dir = "  ";
            branch = " ";
          }
          ''
            Icons displayed in the Telescope picker.
          '';
    };
  };

  settingsExample = {
    use_git_branch = true;
    autoload = true;
    on_autoload_no_session.__raw = ''
      function()
        vim.notify("No existing session to load.")
      end
    '';
  };
}
