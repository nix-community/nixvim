{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.copilot-lua;
in {
  options = {
    plugins.copilot-lua = let
      keymapOption = helpers.defaultNullOpts.mkNullable (with types; either (enum [false]) str);
    in
      helpers.neovim-plugin.extraOptionsOptions
      // {
        enable = mkEnableOption "copilot.lua";

        package = helpers.mkPackageOption "copilot.lua" pkgs.vimPlugins.copilot-lua;

        panel = {
          enabled = helpers.defaultNullOpts.mkBool true "Enable the panel.";

          autoRefresh = helpers.defaultNullOpts.mkBool false "Enable auto-refresh.";

          keymap = {
            jumpPrev = keymapOption "[[" "Keymap for jumping to the previous suggestion.";

            jumpNext = keymapOption "]]" "Keymap for jumping to the next suggestion.";

            accept = keymapOption "<CR>" "Keymap to accept the proposed suggestion.";

            refresh = keymapOption "gr" "Keymap to refresh the suggestions.";

            open = keymapOption "<M-CR>" "Keymap to open.";
          };

          layout = {
            position = helpers.defaultNullOpts.mkEnum ["bottom" "top" "left" "right"] "bottom" ''
              The panel position.
            '';

            ratio = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) "0.4" ''
              The panel ratio.
            '';
          };
        };

        suggestion = {
          enabled = helpers.defaultNullOpts.mkBool true "Enable suggestion.";

          autoTrigger = helpers.defaultNullOpts.mkBool false "Enable auto-trigger.";

          debounce = helpers.defaultNullOpts.mkInt 75 "Debounce.";

          keymap = {
            accept = keymapOption "<M-l>" "Keymap for accepting the suggestion.";

            acceptWord = keymapOption "false" "Keymap for accepting a word suggestion.";

            acceptLine = keymapOption "false" "Keymap for accepting a line suggestion.";

            next = keymapOption "<M-]>" "Keymap for accepting the next suggestion.";

            prev = keymapOption "<M-[>" "Keymap for accepting the previous suggestion.";

            dismiss = keymapOption "<C-]>" "Keymap to dismiss the suggestion.";
          };
        };

        filetypes =
          helpers.defaultNullOpts.mkNullable
          (with types; attrsOf (either bool helpers.nixvimTypes.rawLua))
          ''
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

        copilotNodeCommand = mkOption {
          type = types.str;
          default = "${pkgs.nodejs-18_x}/bin/node";
          description = ''
            Use this field to provide the path to a specific node version such as one installed by
            `nvm`.
            Node.js version must be 16.x or newer.
          '';
        };

        serverOptsOverrides = helpers.defaultNullOpts.mkNullable types.attrs "{}" ''
          Override copilot lsp client `settings`.
          The settings field is where you can set the values of the options defined in
          https://github.com/zbirenbaum/copilot.lua/blob/master/SettingsOpts.md.
          These options are specific to the copilot lsp and can be used to customize its behavior.

          Ensure that the `name` field is not overriden as is is used for efficiency reasons in
          numerous checks to verify copilot is actually running.

          See `:h vim.lsp.start_client` for list of options.

          Example:
          ```nix
            {
              trace = "verbose";
              settings = {
                advanced = {
                  listCount = 10; # number of completions for panel
                  inlineSuggestCount = 3; # number of completions for getCompletions
                };
              };
            }
          ```
        '';
      };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.plugins.copilot-vim.enable;
        message = ''
          You currently have both `copilot-vim` and `copilot-lua` enabled.
          Please disable one of them.
        '';
      }
    ];

    extraPlugins = [cfg.package];

    extraConfigLua = let
      setupOptions = with cfg;
        {
          panel = with panel; {
            inherit enabled;
            auto_refresh = autoRefresh;
            keymap = with keymap; {
              jump_prev = jumpPrev;
              jump_next = jumpNext;
              inherit accept refresh open;
            };
            layout = with layout; {
              inherit position ratio;
            };
          };
          suggestion = with suggestion; {
            inherit enabled;
            auto_trigger = autoTrigger;
            inherit debounce;
            keymap = with keymap; {
              inherit accept;
              accept_word = acceptWord;
              accept_line = acceptLine;
              inherit next prev dismiss;
            };
          };
          inherit filetypes;
          copilot_node_command = copilotNodeCommand;
          server_opts_overrides = serverOptsOverrides;
        }
        // cfg.extraOptions;
    in ''
      require('copilot').setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
