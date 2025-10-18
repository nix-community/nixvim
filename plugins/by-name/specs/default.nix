{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "specs";
  package = "specs-nvim";
  description = "A fast and lightweight Neovim lua plugin to keep an eye on where your cursor has jumped.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    show_jumps = helpers.defaultNullOpts.mkBool true ''
      Whether to show an animation each time the cursor jumps.
    '';

    min_jump = helpers.defaultNullOpts.mkUnsignedInt 30 ''
      Minimum jump distance to trigger the animation.
    '';

    popup = {
      delay_ms = helpers.defaultNullOpts.mkUnsignedInt 10 ''
        Delay before popup displays.
      '';

      inc_ms = helpers.defaultNullOpts.mkUnsignedInt 5 ''
        Time increments used for fade/resize effects.
      '';

      blend = helpers.defaultNullOpts.mkUnsignedInt 10 ''
        Starting blend, between 0 (opaque) and 100 (transparent), see `:h winblend`.
      '';

      width = helpers.defaultNullOpts.mkUnsignedInt 20 ''
        Width of the popup.
      '';

      winhl = helpers.defaultNullOpts.mkStr "PMenu" ''
        The name of the window highlight group of the popup.
      '';

      fader = helpers.defaultNullOpts.mkLuaFn "require('specs').exp_fader" ''
        The fader function to use.
      '';

      resizer = helpers.defaultNullOpts.mkLuaFn "require('specs').shrink_resizer" ''
        The resizer function to use.
      '';
    };

    ignore_filetypes = helpers.defaultNullOpts.mkAttrsOf types.bool { } ''
      An attrs where keys are filetypes and values are a boolean stating whether animation should be
      enabled or not for this filetype.
    '';

    ignore_buftypes = helpers.defaultNullOpts.mkAttrsOf types.bool { nofile = true; } ''
      An attrs where keys are buftypes and values are a boolean stating whether animation should be
      enabled or not for this buftype.
    '';
  };

  settingsExample = {
    show_jumps = true;
    min_jump = 30;
    popup = {
      delay_ms = 0;
      inc_ms = 10;
      blend = 10;
      width = 10;
      winhl = "PMenu";
      fader = ''
        function(blend, cnt)
            if cnt > 100 then
                return 80
            else return nil end
        end
      '';
      resizer = ''
        function(width, ccol, cnt)
            if width-cnt > 0 then
                return {width+cnt, ccol}
            else return nil end
        end
      '';
    };
    ignore_filetypes = { };
    ignore_buftypes = {
      nofile = true;
    };
  };
}
