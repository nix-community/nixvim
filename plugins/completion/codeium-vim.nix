{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.vim-plugin.mkVimPlugin config {
    name = "codeium-vim";
    originalName = "codeium.vim";
    defaultPackage = pkgs.vimPlugins.codeium-vim;
    globalPrefix = "codeium_";

    maintainers = [maintainers.GaetanLepage];

    # TODO introduced 2024-02-19: remove 2024-03-19
    deprecateExtraConfig = true;
    optionsRenamedToSettings = [
      "bin"
      "filetypes"
      "manual"
      "noMapTab"
      "idleDelay"
      "render"
      "tabFallback"
      "disableBindings"
    ];

    settingsOptions = {
      bin = mkOption {
        type = with types; nullOr str;
        default = "${pkgs.codeium}/bin/codeium_language_server";
        description = "The path to the codeium language server executable.";
      };

      filetypes =
        helpers.defaultNullOpts.mkAttrsOf types.bool
        ''
          {
            help = false;
            gitcommit = false;
            gitrebase = false;
            "." = false;
          }
        ''
        ''
          A dictionary mapping whether codeium should be enabled or disabled in certain filetypes.
          This can be used to opt out of completions for certain filetypes.
        '';

      manual = helpers.defaultNullOpts.mkBool false ''
        If true, codeium completions will never automatically trigger.
      '';

      no_map_tab = helpers.defaultNullOpts.mkBool false ''
        Whether to disable the `<Tab>` keybinding.
      '';

      idle_delay = helpers.defaultNullOpts.mkPositiveInt 75 ''
        Delay in milliseconds before autocompletions are shown (limited by language server to a
        minimum of 75).
      '';

      render = helpers.defaultNullOpts.mkBool true ''
        A global boolean flag that controls whether codeium renders are enabled or disabled.
      '';

      tab_fallback = helpers.mkNullOrOption types.str ''
        The fallback key when there is no suggestion display in `codeium#Accept()`.

        Default: "\<C-N>" when a popup menu is visible, else "\t".
      '';

      disable_bindings = helpers.defaultNullOpts.mkBool false ''
        Whether to disable default keybindings.
      '';
    };

    extraOptions = {
      keymaps = {
        clear = helpers.defaultNullOpts.mkStr "<C-]>" ''
          Keymap for clearing current suggestion.
          Command: `codeium#Clear()`
        '';

        next = helpers.defaultNullOpts.mkStr "<M-]>" ''
          Keymap for cycling to the next suggestion.
          Command: `codeium#CycleCompletions(1)`
        '';

        prev = helpers.defaultNullOpts.mkStr "<M-[>" ''
          Keymap for cycling to the previous suggestion.
          Command: `codeium#CycleCompletions(-1)`
        '';

        accept = helpers.defaultNullOpts.mkStr "<Tab>" ''
          Keymap for inserting the proposed suggestion.
          Command: `codeium#Accept()`
        '';

        complete = helpers.defaultNullOpts.mkStr "<M-Bslash>" ''
          Keymap for manually triggering the suggestion.
          Command: `codeium#Complete()`
        '';
      };
    };

    extraConfig = cfg: {
      plugins.codeium-vim.settings.enabled = true;

      keymaps = with cfg.keymaps;
        helpers.keymaps.mkKeymaps
        {
          mode = "i";
          options = {
            silent = true;
            expr = true;
          };
        }
        (
          flatten
          [
            (optional
              (clear != null)
              {
                key = clear;
                action = "<Cmd>call codeium#Clear()<CR>";
              })
            (optional
              (next != null)
              {
                key = next;
                action = "codeium#CycleCompletions(1)";
              })
            (optional
              (prev != null)
              {
                key = prev;
                action = "codeium#CycleCompletions(-1)";
              })
            (optional
              (accept != null)
              {
                key = accept;
                action = "codeium#Accept()";
              })
            (optional
              (complete != null)
              {
                key = complete;
                action = "codeium#Complete()";
              })
          ]
        );
    };
  }
