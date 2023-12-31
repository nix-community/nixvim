{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.codeium-vim;
in {
  meta.maintainers = [maintainers.GaetanLepage];

  options.plugins.codeium-vim = {
    enable = mkEnableOption "codeium.vim";

    package = helpers.mkPackageOption "codeium-vim" pkgs.vimPlugins.codeium-vim;

    bin = mkOption {
      type = with types; nullOr str;
      default = "${pkgs.codeium}/bin/codeium_language_server";
      description = "The path to the codeium language server executable.";
    };

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

    noMapTab = helpers.defaultNullOpts.mkBool false ''
      Whether to disable the `<Tab>` keybinding.
    '';

    idleDelay = helpers.defaultNullOpts.mkPositiveInt 75 ''
      Delay in milliseconds before autocompletions are shown (limited by language server to a
      minimum of 75).
    '';

    render = helpers.defaultNullOpts.mkBool true ''
      A global boolean flag that controls whether codeium renders are enabled or disabled.
    '';

    tabFallback = helpers.mkNullOrOption types.str ''
      The fallback key when there is no suggestion display in `codeium#Accept()`.

      Default: "\<C-N>" when a popup menu is visible, else "\t".
    '';

    disableBindings = helpers.defaultNullOpts.mkBool false ''
      Whether to disable default keybindings.
    '';

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        The configuration options for codeium-vim without the 'codeium_' prefix.
        Example: To set 'codeium_foobar' to 1, write
        extraConfig = {
          foobar = true;
        };
      '';
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    # Add the typst compiler to nixvim packages
    extraPackages = with pkgs; [typst];

    globals =
      mapAttrs'
      (name: nameValuePair ("codeium_" + name))
      (
        with cfg;
          {
            enabled = true;
            inherit
              filetypes
              manual
              bin
              ;
            no_map_tab = noMapTab;
            idle_delay = idleDelay;
            inherit render;
            tab_fallback = tabFallback;
            disable_bindings = disableBindings;
          }
          // extraConfig
      );

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
