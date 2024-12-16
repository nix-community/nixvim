{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "comment";
  packPathName = "Comment.nvim";
  moduleName = "Comment";
  package = "comment-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-24: remove 2024-05-24
  imports =
    let
      oldPluginPath = [
        "plugins"
        "comment-nvim"
      ];
      newPluginPath = [
        "plugins"
        "comment"
      ];
      settingsPath = newPluginPath ++ [ "settings" ];

      optionsRenamedToSettings = import ./renamed-options.nix;
    in
    [
      (mkRenamedOptionModule (oldPluginPath ++ [ "enable" ]) (newPluginPath ++ [ "enable" ]))
      (mkRenamedOptionModule (oldPluginPath ++ [ "package" ]) (newPluginPath ++ [ "package" ]))
      (mkRemovedOptionModule (
        oldPluginPath
        ++ [
          "mappings"
          "extended"
        ]
      ) "This option has been removed upstream.")
    ]
    ++ (lib.nixvim.mkSettingsRenamedOptionModules oldPluginPath settingsPath optionsRenamedToSettings);

  settingsOptions = {
    padding = helpers.defaultNullOpts.mkBool true ''
      Add a space b/w comment and the line.
    '';

    sticky = helpers.defaultNullOpts.mkBool true ''
      Whether the cursor should stay at its position.
    '';

    ignore = helpers.mkNullOrStr ''
      Lines to be ignored while (un)comment.
    '';

    toggler = {
      line = helpers.defaultNullOpts.mkStr "gcc" ''
        Line-comment toggle keymap in NORMAL mode.
      '';

      block = helpers.defaultNullOpts.mkStr "gbc" ''
        Block-comment toggle keymap in NORMAL mode.
      '';
    };

    opleader = {
      line = helpers.defaultNullOpts.mkStr "gc" ''
        Line-comment operator-pending keymap in NORMAL and VISUAL mode.
      '';

      block = helpers.defaultNullOpts.mkStr "gb" ''
        Block-comment operator-pending keymap in NORMAL and VISUAL mode.
      '';
    };

    extra = {
      above = helpers.defaultNullOpts.mkStr "gcO" ''
        Add comment on the line above.
      '';

      below = helpers.defaultNullOpts.mkStr "gco" ''
        Add comment on the line below.
      '';

      eol = helpers.defaultNullOpts.mkStr "gcA" ''
        Add comment at the end of line.
      '';
    };

    mappings =
      helpers.defaultNullOpts.mkNullable
        (
          with types;
          either (enum [ false ]) (submodule {
            options = {
              basic = helpers.defaultNullOpts.mkBool true ''
                Enable operator-pending mappings (`gcc`, `gbc`, `gc[count]{motion}`, `gb[count]{motion}`).
              '';

              extra = helpers.defaultNullOpts.mkBool true ''
                Enable extra mappings (`gco`, `gcO`, `gcA`).
              '';
            };
          })
        )
        {
          basic = true;
          extra = true;
        }
        ''
          Enables keybindings.
          NOTE: If given 'false', then the plugin won't create any mappings.
        '';

    pre_hook = helpers.mkNullOrLuaFn ''
      Lua function called before (un)comment.
    '';

    post_hook = helpers.mkNullOrLuaFn ''
      Lua function called after (un)comment.
    '';
  };

  settingsExample = {
    ignore = "^const(.*)=(%s?)%((.*)%)(%s?)=>";
    toggler = {
      line = "gcc";
      block = "gbc";
    };
    opleader = {
      line = "gc";
      block = "gb";
    };
    pre_hook = "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
    post_hook = ''
      function(ctx)
          if ctx.range.srow == ctx.range.erow then
              -- do something with the current line
          else
              -- do something with lines range
          end
      end
    '';
  };
}
