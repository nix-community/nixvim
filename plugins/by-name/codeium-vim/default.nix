{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
let
  keymapsDefinitions = {
    clear = {
      default = "<C-]>";
      description = "Keymap for clearing current suggestion.";
      command = "vim.fn['codeium#Clear']()";
    };
    next = {
      default = "<M-]>";
      description = "Keymap for cycling to the next suggestion.";
      command = "vim.fn['codeium#CycleCompletions'](1)";
    };
    prev = {
      default = "<M-[>";
      description = "Keymap for cycling to the previous suggestion.";
      command = "vim.fn['codeium#CycleCompletions'](-1)";
    };
    accept = {
      default = "<Tab>";
      description = "Keymap for inserting the proposed suggestion.";
      command = "vim.fn['codeium#Accept']()";
    };
    complete = {
      default = "<M-Bslash>";
      description = "Keymap for manually triggering the suggestion.";
      command = "vim.fn['codeium#Complete']()";
    };
  };
in
lib.nixvim.plugins.mkVimPlugin {
  name = "codeium-vim";
  packPathName = "codeium.vim";
  globalPrefix = "codeium_";

  maintainers = [ maintainers.GaetanLepage ];

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
        {
          help = false;
          gitcommit = false;
          gitrebase = false;
          "." = false;
        }
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
    keymaps = mapAttrs (
      optionName: v:
      helpers.defaultNullOpts.mkStr v.default ''
        ${v.description}
        Command: `${v.command}`
      ''
    ) keymapsDefinitions;
  };

  extraConfig = cfg: {
    plugins.codeium-vim.settings.enabled = true;

    keymaps =
      let
        processKeymap =
          optionName: v:
          optional (v != null) {
            key = v;
            action =
              let
                inherit (keymapsDefinitions.${optionName}) command;
              in
              helpers.mkRaw "function() ${command} end";
          };

        keymapsList = flatten (mapAttrsToList processKeymap cfg.keymaps);

        defaults = {
          mode = "i";
          options = {
            silent = true;
            expr = true;
          };
        };
      in
      helpers.keymaps.mkKeymaps defaults keymapsList;
  };
}
