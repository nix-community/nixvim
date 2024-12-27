{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp";
  packPathName = "blink.cmp";
  package = "blink-cmp";

  maintainers = [ lib.maintainers.balssh ];

  description = ''
    Performant, batteries-included completion plugin for Neovim.
  '';

  settingsOptions = {
    keymap = defaultNullOpts.mkNullableWithRaw' {
      type = with types; either (attrsOf anything) (enum [ false ]);
      pluginDefault = {
        preset = "default";
      };
      example = {
        "<C-space>" = [
          "show"
          "show_documentation"
          "hide_documentation"
        ];
        "<C-e>" = [ "hide" ];
        "<C-y>" = [ "select_and_accept" ];

        "<Up>" = [
          "select_prev"
          "fallback"
        ];
        "<Down>" = [
          "select_next"
          "fallback"
        ];
        "<C-p>" = [
          "select_prev"
          "fallback"
        ];
        "<C-n>" = [
          "select_next"
          "fallback"
        ];

        "<C-b>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<C-f>" = [
          "scroll_documentation_down"
          "fallback"
        ];

        "<Tab>" = [
          "snippet_forward"
          "fallback"
        ];
        "<S-Tab>" = [
          "snippet_backward"
          "fallback"
        ];

      };
      description = ''
        The keymap can be:
        - A preset (`'default'` | `'super-tab'` | `'enter'`)
        - A table of `keys => command[]` (optionally with a "preset" key to merge with a preset)
        When specifying 'preset' in the keymap table, the custom key mappings are merged with the preset,
        and any conflicting keys will overwrite the preset mappings.
      '';
    };

    highlight = {
      use_nvim_cmp_as_default = defaultNullOpts.mkBool false ''
        Sets the fallback highlight groups to nvim-cmp's highlight groups.
      '';
    };

    fuzzy = {
      use_frecency = defaultNullOpts.mkBool true ''
        Enable the `Frecency` integration to boost the score of the most recently/frequently used items.
      '';
      use_proximity = defaultNullOpts.mkBool true ''
        Enables the `Proximity` integration that boosts the score of items with a value in the buffer.
      '';
      max_items = defaultNullOpts.mkUnsignedInt 200 ''
        Maximum number of items shown.
      '';
    };

    windows = {
      documentation = {
        auto_show = defaultNullOpts.mkBool false ''
          Enables automatically showing documentation when typing.
        '';
        auto_show_delay_ms = defaultNullOpts.mkUnsignedInt 500 ''
          Delay, in milliseconds, after which documentation is shown.
        '';
        update_delay_ms = defaultNullOpts.mkUnsignedInt 50 ''
          Delay, in milliseconds, after which documentation is updated.
        '';
      };
    };

    nerd_font_variant =
      defaultNullOpts.mkEnumFirstDefault
        [
          "normal"
          "mono"
        ]
        ''
          Set to `mono` for `Nerd Font Mono` or `normal` for `Nerd Font`.
          Adjusts spacing to ensure icons are aligned.
        '';

    accept = {
      auto_brackets = {
        enabled = defaultNullOpts.mkBool false ''
          Enable experimental auto-brackets support.
        '';
      };
    };
    trigger = {
      signature_help = {
        enabled = defaultNullOpts.mkBool false ''
          Enable experimental signature help support.
        '';
      };
    };
  };

  settingsExample = {
    keymap = {
      preset = "default";
    };
    highlight = {
      use_nvim_cmp_as_default = true;
    };
    documentation = {
      auto_show = false;
    };
    accept = {
      auto_brackets = {
        enabled = false;
      };
    };
    trigger = {
      signature_help = {
        enabled = true;
      };
    };
  };

  extraConfig = cfg: {
    warnings = lib.optional (cfg.settings ? documentation) ''
      Nixvim(plugins.blink): `settings.documentation` does not correspond to a known setting, use `settings.windows.documentation` instead.
    '';

    # After version 0.8.2, if we don't force the version, the plugin return an error after being loaded.
    # This happens because when we use nix to install the plugin, blink.cmp can't find the git hash or git tag that was used to build the plugin.
    plugins.blink-cmp.settings.fuzzy.prebuilt_binaries.force_version = lib.mkIf (
      builtins.compareVersions cfg.package.version "0.8.2" >= 0
    ) (lib.mkDefault "v${cfg.package.version}");
  };
}
