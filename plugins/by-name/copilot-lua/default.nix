{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "copilot-lua";
  moduleName = "copilot";
  description = "Fully featured & enhanced replacement for copilot.vim.";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  dependencies = [
    "curl"
    "nodejs"
  ];

  settingsOptions =
    let
      mkKeymapOption = defaultNullOpts.mkNullableWithRaw (with types; either (enum [ false ]) str);
    in
    {
      panel = {
        enabled = defaultNullOpts.mkBool true "Enable the panel.";
        auto_refresh = defaultNullOpts.mkBool false "Enable auto-refresh.";

        keymap = {
          jump_prev = mkKeymapOption "[[" "Keymap for jumping to the previous suggestion.";
          jump_next = mkKeymapOption "]]" "Keymap for jumping to the next suggestion.";
          accept = mkKeymapOption "<CR>" "Keymap to accept the proposed suggestion.";
          refresh = mkKeymapOption "gr" "Keymap to refresh the suggestions.";
          open = mkKeymapOption "<M-CR>" "Keymap to open.";
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

          ratio = defaultNullOpts.mkProportion 0.4 ''
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
          accept = mkKeymapOption "<M-l>" "Keymap for accepting the suggestion.";
          accept_word = mkKeymapOption false "Keymap for accepting a word suggestion.";
          accept_line = mkKeymapOption false "Keymap for accepting a line suggestion.";
          next = mkKeymapOption "<M-]>" "Keymap for accepting the next suggestion.";
          prev = mkKeymapOption "<M-[>" "Keymap for accepting the previous suggestion.";
          dismiss = mkKeymapOption "<C-]>" "Keymap to dismiss the suggestion.";
        };
      };

      filetypes = defaultNullOpts.mkAttrsOf' {
        type = types.bool;
        pluginDefault = {
          yaml = true;
          markdown = false;
          help = false;
          gitcommit = false;
          gitrebase = false;
          hgcommit = false;
          svn = false;
          cvs = false;
          "." = false;
        };
        example = lib.literalExpression ''
          {
            markdown = true; # overrides default
            terraform = false; # disallow specific filetype
            sh.__raw = '''
              function()
                if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
                  -- disable for .env files
                  return false
                end
                return true
              end
            ''';
            javascript = true; # allow specific type
            "*" = false; # disable for all other filetypes and ignore default filetypes
          }
        '';
        description = ''
          Specify filetypes for attaching copilot.
          Each value can be either a boolean or a lua function that returns a boolean.
        '';
      };

      copilot_node_command = defaultNullOpts.mkStr "node" ''
        Define the node command to use for copilot-lua.
        Node.js version must be 20.x or newer.
      '';

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

          See `:h vim.lsp.start()` for list of options.
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
    };
    suggestion = {
      enabled = true;
      auto_trigger = false;
      hide_during_completion = false;
      debounce = 90;
      keymap = {
        accept_word = false;
        accept_line = false;
      };
    };
  };

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.copilot-lua" {
      assertion = !config.plugins.copilot-vim.enable;
      message = ''
        You currently have both `copilot-vim` and `copilot-lua` enabled.
        Please disable one of them.
      '';
    };

    extraPlugins = [
      # Next edit suggestion support
      pkgs.vimPlugins.copilot-lsp
    ];
  };
}
