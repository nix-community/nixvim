{
  lib,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "comment";
  moduleName = "Comment";
  package = "comment-nvim";
  description = "Smart and powerful comment plugin for Neovim.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    padding = lib.nixvim.defaultNullOpts.mkBool true ''
      Add a space b/w comment and the line.
    '';

    sticky = lib.nixvim.defaultNullOpts.mkBool true ''
      Whether the cursor should stay at its position.
    '';

    ignore = lib.nixvim.mkNullOrStr ''
      Lines to be ignored while (un)comment.
    '';

    toggler = {
      line = lib.nixvim.defaultNullOpts.mkStr "gcc" ''
        Line-comment toggle keymap in NORMAL mode.
      '';

      block = lib.nixvim.defaultNullOpts.mkStr "gbc" ''
        Block-comment toggle keymap in NORMAL mode.
      '';
    };

    opleader = {
      line = lib.nixvim.defaultNullOpts.mkStr "gc" ''
        Line-comment operator-pending keymap in NORMAL and VISUAL mode.
      '';

      block = lib.nixvim.defaultNullOpts.mkStr "gb" ''
        Block-comment operator-pending keymap in NORMAL and VISUAL mode.
      '';
    };

    extra = {
      above = lib.nixvim.defaultNullOpts.mkStr "gcO" ''
        Add comment on the line above.
      '';

      below = lib.nixvim.defaultNullOpts.mkStr "gco" ''
        Add comment on the line below.
      '';

      eol = lib.nixvim.defaultNullOpts.mkStr "gcA" ''
        Add comment at the end of line.
      '';
    };

    mappings =
      lib.nixvim.defaultNullOpts.mkNullable
        (
          with types;
          either (enum [ false ]) (submodule {
            options = {
              basic = lib.nixvim.defaultNullOpts.mkBool true ''
                Enable operator-pending mappings (`gcc`, `gbc`, `gc[count]{motion}`, `gb[count]{motion}`).
              '';

              extra = lib.nixvim.defaultNullOpts.mkBool true ''
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

    pre_hook = lib.nixvim.mkNullOrLuaFn ''
      Lua function called before (un)comment.
    '';

    post_hook = lib.nixvim.mkNullOrLuaFn ''
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
