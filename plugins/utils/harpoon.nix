{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.harpoon;
  helpers = import ../helpers.nix {inherit lib;};

  projectConfigModule = types.submodule {
    options = {
      termCommands = helpers.mkNullOrOption (types.listOf types.str) ''
        List of predefined terminal commands for this project.
      '';

      marks = helpers.mkNullOrOption (types.listOf types.str) ''
        List of predefined marks (filenames) for this project.
      '';
    };
  };
in {
  options.plugins.harpoon = {
    enable = mkEnableOption "harpoon";

    package = helpers.mkPackageOption "harpoon" pkgs.vimPlugins.harpoon;

    saveOnToggle = helpers.defaultNullOpts.mkBool false ''
      Sets the marks upon calling `toggle` on the ui, instead of require `:w`.
    '';

    saveOnChange = helpers.defaultNullOpts.mkBool true ''
      Saves the harpoon file upon every change. disabling is unrecommended.
    '';

    enterOnSendcmd = helpers.defaultNullOpts.mkBool false ''
      Sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    '';

    tmuxAutocloseWindows = helpers.defaultNullOpts.mkBool false ''
      Closes any tmux windows harpoon that harpoon creates when you close Neovim.
    '';

    excludedFiletypes = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "['harpoon']" ''
      Filetypes that you want to prevent from adding to the harpoon list menu.
    '';

    markBranch = helpers.defaultNullOpts.mkBool false ''
      Set marks specific to each git branch inside git repository
    '';

    projects = mkOption {
      default = {};
      description = ''
        Predefined projetcs. The keys of this attrs should be the path to the project.
        $HOME is working.
      '';
      example = ''
        projects = {
          "$HOME/personal/vim-with-me/server" = {
            term.cmds = [
                "./env && npx ts-node src/index.ts"
            ];
          };
        };
      '';
      type = types.attrsOf projectConfigModule;
    };

    menu = {
      width = helpers.defaultNullOpts.mkInt 60 ''
        Menu window width
      '';

      height = helpers.defaultNullOpts.mkInt 10 ''
        Menu window height
      '';

      borderChars =
        helpers.defaultNullOpts.mkNullable (types.listOf types.str)
        "[ \"─\" \"│\" \"─\" \"│\" \"╭\" \"╮\" \"╯\" \"╰\" ]"
        "Border characters";
    };
  };

  config = let
    projects =
      builtins.mapAttrs
      (
        name: value: {
          term.cmds = value.termCommands;
          mark.marks = map (mark: {filename = mark;}) value.marks;
        }
      )
      cfg.projects;

    options = {
      global_settings = {
        save_on_toggle = cfg.saveOnToggle;
        save_on_change = cfg.saveOnChange;
        enter_on_sendcmd = cfg.enterOnSendcmd;
        tmux_autoclose_windows = cfg.tmuxAutocloseWindows;
        excluded_filetypes = cfg.excludedFiletypes;
        mark_branch = cfg.markBranch;
      };

      projects = projects;

      menu = {
        width = cfg.menu.width;
        height = cfg.menu.height;
        borderchars = cfg.menu.borderChars;
      };
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('harpoon').setup(${helpers.toLuaObject options})
      '';
    };
}
