{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "zen-mode";
  originalName = "zen-mode.nvim";
  package = "zen-mode-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  # Optionally, explicitly declare some options. You don't have to.
  settingsOptions = {
    window = {
      backdrop = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.95 ''
        Shade the backdrop of the Zen window.
        Set to 1 to keep the same as Normal.
      '';

      width =
        helpers.defaultNullOpts.mkNullable
          (
            with lib.types;
            oneOf [
              ints.positive
              (numbers.between 0.0 1.0)
              rawLua
            ]
          )
          120
          ''
            Width of the zen window.

            Can be:
            - an absolute number of cells when > 1
            - a percentage of the width / height of the editor when <= 1
            - a function that returns the width or the height
          '';

      height =
        helpers.defaultNullOpts.mkNullable
          (
            with lib.types;
            oneOf [
              ints.positive
              (numbers.between 0.0 1.0)
              rawLua
            ]
          )
          1
          ''
            Height of the Zen window.

            Can be:
            - an absolute number of cells when > 1
            - a percentage of the width / height of the editor when <= 1
            - a function that returns the width or the height
          '';

      options = helpers.defaultNullOpts.mkAttrsOf types.anything { } ''
        By default, no options are changed for the Zen window.
        You can set any `vim.wo` option here.

        Example:
        ```nix
          {
            signcolumn = "no";
            number = false;
            relativenumber = false;
            cursorline = false;
            cursorcolumn = false;
            foldcolumn = "0";
            list = false;
          }
        ```
      '';
    };
    plugins = {
      options =
        helpers.defaultNullOpts.mkAttrsOf types.anything
          {
            enabled = true;
            ruler = false;
            showcmd = false;
            laststatus = 0;
          }
          ''
            Disable some global vim options (`vim.o`...).
          '';
    };

    on_open = helpers.defaultNullOpts.mkLuaFn "function(win) end" ''
      Callback where you can add custom code when the Zen window opens.
    '';

    on_close = helpers.defaultNullOpts.mkLuaFn "function(win) end" ''
      Callback where you can add custom code when the Zen window closes.
    '';
  };

  settingsExample = {
    window = {
      backdrop = 0.95;
      width = 0.8;
      height = 1;
      options.signcolumn = "no";
    };
    plugins = {
      options = {
        enabled = true;
        ruler = false;
        showcmd = false;
      };
      twilight.enabled = false;
      gitsigns.enabled = true;
      tmux.enabled = false;
    };
    on_open = ''
      function()
        require("gitsigns.actions").toggle_current_line_blame()
        vim.cmd('IBLDisable')
        vim.opt.relativenumber = false
        vim.opt.signcolumn = "no"
        require("gitsigns.actions").refresh()
      end
    '';
    on_close = ''
      function()
        require("gitsigns.actions").toggle_current_line_blame()
        vim.cmd('IBLEnable')
        vim.opt.relativenumber = true
        vim.opt.signcolumn = "yes:2"
        require("gitsigns.actions").refresh()
      end
    '';
  };
}
