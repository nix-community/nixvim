{ lib, ... }:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "better-escape";
  moduleName = "better_escape";
  package = "better-escape-nvim";
  description = "A Neovim plugin to quickly exit insert mode without losing your typed text.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    timeout = lib.nixvim.defaultNullOpts.mkStrLuaOr types.ints.unsigned "vim.o.timeoutlen" ''
      The time in which the keys must be hit in ms.
      Uses the value of `vim.o.timeoutlen` (`options.timeoutlen` in nixvim) by default.
    '';

    default_mappings = lib.nixvim.defaultNullOpts.mkBool true ''
      Whether to enable default key mappings.
    '';

    mappings = lib.nixvim.defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = {
        i.j = {
          k = "<Esc>";
          j = "<Esc>";
        };
        c.j = {
          k = "<Esc>";
          j = "<Esc>";
        };
        t.j = {
          k = "<Esc>";
          j = "<Esc>";
        };
        v.j.k = "<Esc>";
        s.j.k = "<Esc>";
      };
      example.i." "."<tab>".__raw = ''
          function()
            -- Defer execution to avoid side-effects
            vim.defer_fn(function()
                -- set undo point
                vim.o.ul = vim.o.ul
                require("luasnip").expand_or_jump()
            end, 1)
        end
      '';
      description = "Define mappings for each mode.";
    };
  };

  settingsExample = {
    timeout = "vim.o.timeoutlen";
    mapping = {
      i." "."<tab>".__raw = ''
        function()
          -- Defer execution to avoid side-effects
          vim.defer_fn(function()
              -- set undo point
              vim.o.ul = vim.o.ul
              require("luasnip").expand_or_jump()
          end, 1)
        end
      '';
    };
  };
}
