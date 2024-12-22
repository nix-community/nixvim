{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "better-escape";
  packPathName = "better-escape.nvim";
  moduleName = "better_escape";
  package = "better-escape-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO: introduced 2024-07-23. Remove after 24.11 release.
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [ "timeout" ];
  imports =
    let
      basePluginPath = [
        "plugins"
        "better-escape"
      ];
    in
    [
      (mkRemovedOptionModule (basePluginPath ++ [ "clearEmptyLines" ]) ''
        This option has been removed upstream.
        See the [upstream README](https://github.com/max397574/better-escape.nvim?tab=readme-ov-file#rewrite) for additional information.
      '')
      (mkRemovedOptionModule (basePluginPath ++ [ "keys" ]) ''
        This option has been removed upstream.
        See the [upstream README](https://github.com/max397574/better-escape.nvim?tab=readme-ov-file#rewrite) for additional information.
      '')
      (mkRemovedOptionModule (basePluginPath ++ [ "mapping" ]) ''
        This option has been removed in favor of `plugins.better-escape.settings.mapping`.
        See the [upstream README](https://github.com/max397574/better-escape.nvim?tab=readme-ov-file#rewrite) for additional information.
      '')
    ];

  settingsOptions = {
    timeout = helpers.defaultNullOpts.mkStrLuaOr types.ints.unsigned "vim.o.timeoutlen" ''
      The time in which the keys must be hit in ms.
      Uses the value of `vim.o.timeoutlen` (`options.timeoutlen` in nixvim) by default.
    '';

    default_mappings = helpers.defaultNullOpts.mkBool true ''
      Whether to enable default key mappings.
    '';

    mappings = helpers.defaultNullOpts.mkAttrsOf' {
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
