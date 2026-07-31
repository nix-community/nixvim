{ lib, config, ... }:
let
  keymapType = lib.nixvim.keymaps.mkMapOptionSubmodule { action = false; };
  hoverKeymap =
    { description, exampleKey }:
    lib.mkOption {
      type = lib.types.nullOr keymapType;
      default = null;
      inherit description;
      example = {
        key = exampleKey;
        mode = "n";
      };
    };
  hoverKeymapEntry =
    {
      action,
      function ? "${action}()",
    }:
    let
      mapping = config.plugins.hover.keymaps.${action};
    in
    lib.mkIf (mapping != null) (
      lib.mkMerge [
        mapping
        {
          action = lib.nixvim.mkRaw /* lua */ ''
            function()
              require('hover').${function}
            end
          '';
          options.desc = lib.mkDefault "hover.nvim (${function})";
        }
      ]
    );
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hover";
  package = "hover-nvim";
  setup = ".config";

  description = /* markdown */ ''
    General framework for context aware hover providers (similar to vim.lsp.buf.hover).
    You should also create keybinds for:
    - `require("hover").open()`
    - `require("hover").enter()`
    - `require("hover").switch()`
    - `require("hover").switch("previous")`
    - `require("hover").switch("next")`

    Also, create a bind from `<MouseMove>` to `require("hover").mouse()` and set `opts.mousemoveevent = true`.
  '';

  maintainers = [ lib.maintainers.libewa ];

  settingsExample = {
    providers = [
      "hover.providers.diagnostic"
      "hover.providers.lsp"
      "hover.providers.dap"
      "hover.providers.man"
      "hover.providers.dictionary"
    ];
    preview_opts.border = "single";
    preview_window = false;
    title = true;
    mouse_providers = [ "hover.providers.lsp" ];
    mouse_delay = 1000;
  };
  extraOptions = {
    keymaps = {
      open = hoverKeymap {
        description = "A keymap to open the hover window.";
        exampleKey = "K";
      };
      enter = hoverKeymap {
        description = "A keymap to enter the hover window for scrolling.";
        exampleKey = "gK";
      };
      previous = hoverKeymap {
        description = "A keymap to switch to the previous Hover provider.";
        exampleKey = "<C-p";
      };
      next = hoverKeymap {
        description = "A keymap to switch to the next Hover provider.";
        exampleKey = "<C-n>";
      };
    };
    enableMouse = lib.mkEnableOption "mouse hover support";
  };
  extraConfig = {
    keymaps = [
      (hoverKeymapEntry { action = "open"; })
      (hoverKeymapEntry { action = "enter"; })
      (hoverKeymapEntry {
        action = "previous";
        function = "switch('previous')";
      })
      (hoverKeymapEntry {
        action = "next";
        function = "switch('next')";
      })
      (lib.mkIf config.plugins.hover.enableMouse {
        key = "<MouseMove>";
        action = lib.nixvim.mkRaw "require('hover').mouse";
        options.remap = true;
        options.desc = "hover.nvim (mouse)";
      })
    ];
    opts = lib.mkIf config.plugins.hover.enableMouse {
      mousemoveevent = true;
    };
  };
}
