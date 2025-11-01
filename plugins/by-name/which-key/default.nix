{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;

  specExamples = [
    # Basic group with custom icon
    {
      __unkeyed-1 = "<leader>b";
      group = "Buffers";
      icon = "󰓩 ";
    }
    # Non-default mode
    {
      __unkeyed = "<leader>c";
      mode = "v";
      group = "Codesnap";
      icon = "󰄄 ";
    }
    # Group within group
    {
      __unkeyed-1 = "<leader>bs";
      group = "Sort";
      icon = "󰒺 ";
    }
    # Nested mappings for inheritance
    {
      mode = [
        "n"
        "v"
      ];
      __unkeyed-1 = [
        {
          __unkeyed-1 = "<leader>f";
          group = "Normal Visual Group";
        }
        {
          __unkeyed-1 = "<leader>f<tab>";
          group = "Normal Visual Group in Group";
        }
      ];
    }
    # Proxy mapping
    {
      __unkeyed-1 = "<leader>w";
      proxy = "<C-w>";
      group = "windows";
    }
    # Create mapping
    {
      __unkeyed-1 = "<leader>cS";
      __unkeyed-2 = "<cmd>CodeSnapSave<CR>";
      mode = "v";
      desc = "Save";
    }
    # Function mapping
    {
      __unkeyed-1 = "<leader>db";
      __unkeyed-2.__raw = ''
        function()
          require("dap").toggle_breakpoint()
        end
      '';
      mode = "n";
      desc = "Breakpoint toggle";
      silent = true;
    }
  ];

in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "which-key";
  package = "which-key-nvim";
  description = "Neovim plugin for displaying keybindings in a popup window.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    filter = defaultNullOpts.mkLuaFn' {
      pluginDefault = lib.nixvim.literalLua ''
        function(mapping)
          return true
        end
      '';
      description = "Filter used to exclude mappings";
    };

    defer = defaultNullOpts.mkLuaFn' {
      pluginDefault = lib.nixvim.literalLua ''
        function(ctx)
          return ctx.mode == "V" or ctx.mode == "<C-V>
         end'';
      description = ''
        Start hidden and wait for a key to be pressed before showing the popup.

        Only used by enabled xo mapping modes.
      '';
    };

    replace = {
      key = defaultNullOpts.mkListOf (with types; either strLuaFn (listOf str)) (lib.nixvim.literalLua ''
        function(key)
          return require("which-key.view").format(key)
        end
      '') "Lua functions or list of strings to replace key left side key name with.";
    };
  };

  settingsExample = {
    preset = false;

    delay = 200;

    spec = specExamples;

    replace = {
      desc = [
        [
          "<space>"
          "SPACE"
        ]
        [
          "<leader>"
          "SPACE"
        ]
        [
          "<[cC][rR]>"
          "RETURN"
        ]
        [
          "<[tT][aA][bB]>"
          "TAB"
        ]
        [
          "<[bB][sS]>"
          "BACKSPACE"
        ]
      ];
    };

    notify = false;

    win = {
      border = "single";
    };

    expand = 1;
  };
}
