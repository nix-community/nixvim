{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "markview";
  originalName = "markview.nvim";
  package = "markview-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    An experimental markdown previewer for Neovim.

    Supports a vast amount of rendering customization.
    Please refer to the plugin's [documentation](https://github.com/OXY2DEV/markview.nvim/wiki/Configuration-options) for more details.
  '';

  settingsOptions = {
    buf_ignore = defaultNullOpts.mkListOf types.str [ "nofile" ] ''
      Buftypes to disable markview-nvim.
    '';

    modes =
      defaultNullOpts.mkListOf types.str
        [
          "n"
          "no"
        ]
        ''
          Modes where preview is enabled.
        '';

    hybrid_modes = defaultNullOpts.mkListOf types.str null ''
      Modes where hybrid mode is enabled.
    '';

    callback = {
      on_enable = defaultNullOpts.mkLuaFn' {
        pluginDefault = # Lua
          ''
            function(buf, win)
              vim.wo[window].conceallevel = 2;
              vim.wo[window].concealcursor = "nc";
            end
          '';
        description = ''
          Action to perform when markview is enabled.
        '';
      };

      on_disable = defaultNullOpts.mkLuaFn' {
        pluginDefault = # Lua
          ''
            function(buf, win)
                vim.wo[window].conceallevel = 0;
                vim.wo[window].concealcursor = "";
            end
          '';
        description = ''
          Action to perform when markview is disabled.
        '';
      };

      on_mode_change = defaultNullOpts.mkLuaFn' {
        pluginDefault = # Lua
          ''
            function(buf, win, mode)
              if vim.list_contains(markview.configuration.modes, mode) then
                vim.wo[window].conceallevel = 2;
              else
                vim.wo[window].conceallevel = 0;
              end
            end
          '';
        description = ''
          Action to perform when mode is changed, while the plugin is enabled.
        '';
      };
    };
  };

  settingsExample = {
    buf_ignore = [ ];
    modes = [
      "n"
      "x"
    ];
    hybrid_modes = [
      "i"
      "r"
    ];
  };
}
