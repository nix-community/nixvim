{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;

  keymapOption = defaultNullOpts.mkNullableWithRaw (with types; either (enum [ false ]) str);
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "copilot-lua";
  moduleName = "copilot";
  packPathName = "copilot.lua";
  package = "copilot-lua";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    panel = {
      enabled = defaultNullOpts.mkBool true "Enable the panel.";
      auto_refresh = defaultNullOpts.mkBool false "Enable auto-refresh.";

      keymap = {
        jump_prev = keymapOption "[[" "Keymap for jumping to the previous suggestion.";
        jump_next = keymapOption "]]" "Keymap for jumping to the next suggestion.";
        accept = keymapOption "<CR>" "Keymap to accept the proposed suggestion.";
        refresh = keymapOption "gr" "Keymap to refresh the suggestions.";
        open = keymapOption "<M-CR>" "Keymap to open.";
      };

      layout = {
        position =
          defaultNullOpts.mkEnumFirstDefault
            [
              "bottom"
              "top"
              "left"
              "right"
              "horizontal"
              "vertical"
            ]
            ''
              The panel position.
            '';

        ratio = defaultNullOpts.mkNullableWithRaw (types.numbers.between 0.0 1.0) 0.4 ''
          The panel ratio.
        '';
      };
    };

    suggestion = {
      enabled = defaultNullOpts.mkBool true "Enable suggestion.";
      auto_trigger = defaultNullOpts.mkBool false "Enable auto-trigger.";
      hide_during_completion = defaultNullOpts.mkBool true "Hide during completion.";
      debounce = defaultNullOpts.mkInt 75 "Debounce.";

      keymap = {
        accept = keymapOption "<M-l>" "Keymap for accepting the suggestion.";
        accept_word = keymapOption false "Keymap for accepting a word suggestion.";
        accept_line = keymapOption false "Keymap for accepting a line suggestion.";
        next = keymapOption "<M-]>" "Keymap for accepting the next suggestion.";
        prev = keymapOption "<M-[>" "Keymap for accepting the previous suggestion.";
        dismiss = keymapOption "<C-]>" "Keymap to dismiss the suggestion.";
      };
    };

    filetypes =
      defaultNullOpts.mkAttrsOf types.bool
        {
          yaml = false;
          markdown = false;
          help = false;
          gitcommit = false;
          gitrebase = false;
          hgcommit = false;
          svn = false;
          cvs = false;
          "." = false;
        }
        ''
          Specify filetypes for attaching copilot.
          Each value can be either a boolean or a lua function that returns a boolean.

          Example:
          ```nix
            {
              markdown = true; # overrides default
              terraform = false; # disallow specific filetype
              sh.__raw = \'\'
                function ()
                  if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
                    -- disable for .env files
                    return false
                  end
                  return true
                end
              \'\';
            }
          ```

          The key `"*"` can be used to disable the default configuration.
          Example:
          ```nix
            {
              javascript = true; # allow specific filetype
              typescript = true; # allow specific filetype
              "*" = false; # disable for all other filetypes and ignore default `filetypes`
            }
          ```
        '';

    copilot_node_command = lib.mkOption {
      type = types.str;
      default = lib.getExe pkgs.nodejs-18_x;
      example = lib.getExe pkgs.nodejs;
      description = ''
        Define the node command to use for copilot-lua.

        Node.js version must be 18.x or newer.
      '';
    };

    server_opts_overrides = defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = { };
      description = ''
        Override copilot lsp client `settings`.
        The settings field is where you can set the values of the options defined in
        https://github.com/zbirenbaum/copilot.lua/blob/master/SettingsOpts.md.
        These options are specific to the copilot lsp and can be used to customize its behavior.

        Ensure that the `name` field is not overridden as is is used for efficiency reasons in
        numerous checks to verify copilot is actually running.

        See `:h vim.lsp.start_client` for list of options.
      '';
      example = {
        trace = "verbose";
        settings = {
          advanced = {
            listCount = 10; # number of completions for panel
            inlineSuggestCount = 3; # number of completions for getCompletions
          };
        };
      };
    };
  };

  settingsExample = {
    panel = {
      enabled = true;
      auto_refresh = true;
      keymap = {
        jump_prev = "[[";
        jump_next = "]]";
        accept = "<CR>";
        refresh = "gr";
        open = "<M-CR>";
      };
      layout = {
        position = "top";
        ratio = 0.5;
      };
    };
    suggestion = {
      enabled = true;
      auto_trigger = false;
      hide_during_completion = false;
      debounce = 90;
      keymap = {
        accept = "<M-l>";
        accept_word = false;
        accept_line = false;
        next = "<M-]>";
        prev = "<M-[>";
        dismiss = "<C-]>";
      };
    };
    filetypes = {
      yaml = true;
      markdown = true;
      help = true;
      gitcommit = true;
      gitrebase = true;
      hgcommit = true;
      svn = true;
      cvs = true;
      "." = true;
    };
    server_opts_overrides = {
      trace = "verbose";
      settings = {
        advanced = {
          listCount = 10; # number of completions for panel
          inlineSuggestCount = 3; # number of completions for getCompletions
        };
      };
    };
  };

  deprecateExtraOptions = true;
  optionsRenamedToSettings =
    let
      panelOptions = [
        "enabled"
        "autoRefresh"
      ];
      panelKeymapOptions = [
        "jumpPrev"
        "jumpNext"
        "accept"
        "refresh"
        "open"
      ];
      panelLayoutOptions = [
        "position"
        "ratio"
      ];
      suggestionOptions = [
        "enabled"
        "autoTrigger"
        "debounce"
      ];
      suggestionKeymapOptions = [
        "accept"
        "acceptWord"
        "acceptLine"
        "next"
        "prev"
        "dismiss"
      ];
    in
    [
      "filetypes"
      "copilotNodeCommand"
      "serverOptsOverrides"
    ]
    ++ map (oldOption: [
      "panel"
      oldOption
    ]) panelOptions
    ++ map (oldOption: [
      "panel"
      "keymap"
      oldOption
    ]) panelKeymapOptions
    ++ map (oldOption: [
      "panel"
      "layout"
      oldOption
    ]) panelLayoutOptions
    ++ map (oldOption: [
      "suggestion"
      oldOption
    ]) suggestionOptions
    ++ map (oldOption: [
      "suggestion"
      "keymap"
      oldOption
    ]) suggestionKeymapOptions;

  extraConfig = {
    assertions = [
      {
        assertion = !config.plugins.copilot-vim.enable;
        message = ''
          You currently have both `copilot-vim` and `copilot-lua` enabled.
          Please disable one of them.
        '';
      }
    ];
  };
}
