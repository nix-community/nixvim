{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.harpoon;

  projectConfigModule = types.submodule {
    options = {
      termCommands = helpers.mkNullOrOption (with types; listOf str) ''
        List of predefined terminal commands for this project.
      '';

      marks = helpers.mkNullOrOption (with types; listOf str) ''
        List of predefined marks (filenames) for this project.
      '';
    };
  };
in
{
  options.plugins.harpoon = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption "harpoon";

    package = lib.mkPackageOption pkgs "harpoon" {
      default = [
        "vimPlugins"
        "harpoon"
      ];
    };

    enableTelescope = mkEnableOption "telescope integration";

    keymapsSilent = mkOption {
      type = types.bool;
      description = "Whether harpoon keymaps should be silent.";
      default = false;
    };

    keymaps = {
      addFile = helpers.mkNullOrOption types.str ''
        Keymap for marking the current file.";
      '';

      toggleQuickMenu = helpers.mkNullOrOption types.str ''
        Keymap for toggling the quick menu.";
      '';

      navFile = helpers.mkNullOrOption (with types; attrsOf str) ''
        Keymaps for navigating to marks.

        Examples:
        navFile = {
          "1" = "<C-j>";
          "2" = "<C-k>";
          "3" = "<C-l>";
          "4" = "<C-m>";
        };
      '';

      navNext = helpers.mkNullOrOption types.str ''
        Keymap for navigating to next mark.";
      '';

      navPrev = helpers.mkNullOrOption types.str ''
        Keymap for navigating to previous mark.";
      '';

      gotoTerminal = helpers.mkNullOrOption (with types; attrsOf str) ''
        Keymaps for navigating to terminals.

        Examples:
        gotoTerminal = {
          "1" = "<C-j>";
          "2" = "<C-k>";
          "3" = "<C-l>";
          "4" = "<C-m>";
        };
      '';

      cmdToggleQuickMenu = helpers.mkNullOrOption types.str ''
        Keymap for toggling the cmd quick menu.
      '';

      tmuxGotoTerminal = helpers.mkNullOrOption (with types; attrsOf str) ''
        Keymaps for navigating to tmux windows/panes.
        Attributes can either be tmux window ids or pane identifiers.

        Examples:
        tmuxGotoTerminal = {
          "1" = "<C-1>";
          "2" = "<C-2>";
          "{down-of}" = "<leader>g";
        };
      '';
    };

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

    excludedFiletypes = helpers.defaultNullOpts.mkListOf types.str [ "harpoon" ] ''
      Filetypes that you want to prevent from adding to the harpoon list menu.
    '';

    markBranch = helpers.defaultNullOpts.mkBool false ''
      Set marks specific to each git branch inside git repository.
    '';

    projects = mkOption {
      default = { };
      description = ''
        Predefined projetcs. The keys of this attrs should be the path to the project.
        $HOME is working.
      '';
      example = ''
        projects = {
          "$HOME/personal/vim-with-me/server" = {
            termCommands = [
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

      borderChars = helpers.defaultNullOpts.mkListOf types.str [
        "─"
        "│"
        "─"
        "│"
        "╭"
        "╮"
        "╯"
        "╰"
      ] "Border characters";
    };
  };

  config =
    let
      projects = builtins.mapAttrs (name: value: {
        term.cmds = value.termCommands;
        mark.marks = helpers.ifNonNull' value.marks (map (mark: { filename = mark; }) value.marks);
      }) cfg.projects;

      setupOptions =
        with cfg;
        {
          global_settings = {
            save_on_toggle = saveOnToggle;
            save_on_change = saveOnChange;
            enter_on_sendcmd = enterOnSendcmd;
            tmux_autoclose_windows = tmuxAutocloseWindows;
            excluded_filetypes = excludedFiletypes;
            mark_branch = markBranch;
          };

          inherit projects;

          menu = {
            inherit (menu) width height;
            borderchars = menu.borderChars;
          };
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
          message = ''Nixvim: The harpoon telescope integration needs telescope to function as intended'';
        }
      ];

      extraPlugins = [ cfg.package ];

      extraConfigLua =
        let
          telescopeCfg = ''require("telescope").load_extension("harpoon")'';
        in
        ''
          require('harpoon').setup(${lib.nixvim.toLuaObject setupOptions})
          ${if cfg.enableTelescope then telescopeCfg else ""}
        '';

      keymaps =
        let
          km = cfg.keymaps;

          simpleMappings = flatten (
            mapAttrsToList
              (
                optionName: luaFunc:
                let
                  key = km.${optionName};
                in
                optional (key != null) {
                  inherit key;
                  action.__raw = luaFunc;
                }
              )
              {
                addFile = "require('harpoon.mark').add_file";
                toggleQuickMenu = "require('harpoon.ui').toggle_quick_menu";
                navNext = "require('harpoon.ui').nav_next";
                navPrev = "require('harpoon.ui').nav_prev";
                cmdToggleQuickMenu = "require('harpoon.cmd-ui').toggle_quick_menu";
              }
          );

          mkNavMappings =
            name: genLuaFunc:
            let
              mappingsAttrs = km.${name};
            in
            flatten (
              optionals (mappingsAttrs != null) (
                mapAttrsToList (id: key: {
                  inherit key;
                  action.__raw = genLuaFunc id;
                }) mappingsAttrs
              )
            );

          allMappings =
            simpleMappings
            ++ (mkNavMappings "navFile" (id: "function() require('harpoon.ui').nav_file(${id}) end"))
            ++ (mkNavMappings "gotoTerminal" (id: "function() require('harpoon.term').gotoTerminal(${id}) end"))
            ++ (mkNavMappings "tmuxGotoTerminal" (
              id: "function() require('harpoon.tmux').gotoTerminal(${id}) end"
            ));
        in
        helpers.keymaps.mkKeymaps {
          mode = "n";
          options.silent = cfg.keymapsSilent;
        } allMappings;
    };
}
