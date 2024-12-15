{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "nvim-lightbulb";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-02-15. Remove on 2024-03-15
  imports =
    map
      (
        optionName:
        mkRemovedOptionModule [
          "plugins"
          "nvim-lightbulb"
          optionName
        ] "Please use `plugins.nvim-lightbulb.settings` instead."
      )
      [
        "ignore"
        "sign"
        "float"
        "virtualText"
        "statusText"
        "autocmd"
      ];

  settingsOptions = {
    priority = helpers.defaultNullOpts.mkUnsignedInt 10 ''
      Priority of the lightbulb for all handlers except float.
    '';

    hide_in_unfocused_buffer = helpers.defaultNullOpts.mkBool true ''
      Whether or not to hide the lightbulb when the buffer is not focused.
      Only works if configured during `NvimLightbulb.setup`.
    '';

    link_highlights = helpers.defaultNullOpts.mkBool true ''
      Whether or not to link the highlight groups automatically.
      Default highlight group links:
        - `LightBulbSign` -> `DiagnosticSignInfo`
        - `LightBulbFloatWin` -> `DiagnosticFloatingInfo`
        - `LightBulbVirtualText` -> `DiagnosticVirtualTextInfo`
        - `LightBulbNumber` -> `DiagnosticSignInfo`
        - `LightBulbLine` -> `CursorLine`

      Only works if configured during `NvimLightbulb.setup`.
    '';

    validate_config =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "auto"
          "always"
          "never"
        ]
        ''
          Perform full validation of configuration.

            - "auto" only performs full validation in `NvimLightbulb.setup`.
            - "always" performs full validation in `NvimLightbulb.update_lightbulb` as well.
            - "never" disables config validation.
        '';

    action_kinds = helpers.mkNullOrOption (with types; listOf str) ''
      Code action kinds to observe.
      To match all code actions, set to `null`.
      Otherwise, set to a list of kinds.

      Example:
      ```nix
        [
          "quickfix"
          "refactor.rewrite"
        ]
      ```
      See: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeActionKind
    '';

    sign = {
      enabled = helpers.defaultNullOpts.mkBool true "Sign column.";

      text = helpers.defaultNullOpts.mkStr "💡" ''
        Text to show in the sign column.
        Must be between 1-2 characters.
      '';

      hl = helpers.defaultNullOpts.mkStr "LightBulbSign" ''
        Highlight group to highlight the sign column text.
      '';
    };

    virtual_text = {
      enabled = helpers.defaultNullOpts.mkBool false "Virtual text.";

      text = helpers.defaultNullOpts.mkStr "💡" "Text to show in the virt_text.";

      pos = helpers.defaultNullOpts.mkStr "eol" ''
        Position of virtual text given to |nvim_buf_set_extmark|.
        Can be a number representing a fixed column (see `virt_text_pos`).
        Can be a string representing a position (see `virt_text_win_col`).
      '';

      hl = helpers.defaultNullOpts.mkStr "LightBulbVirtualText" ''
        Highlight group to highlight the virtual text.
      '';

      hl_mode = helpers.defaultNullOpts.mkStr "combine" ''
        How to combine other highlights with text highlight.
        See `hl_mode` of |nvim_buf_set_extmark|.
      '';
    };

    float = {
      enabled = helpers.defaultNullOpts.mkBool false "Floating window.";

      text = helpers.defaultNullOpts.mkStr "💡" "Text to show in the floating window.";

      hl = helpers.defaultNullOpts.mkStr "LightBulbFloatWin" ''
        Highlight group to highlight the floating window.
      '';

      win_opts = helpers.defaultNullOpts.mkAttrsOf types.anything { } ''
        Window options.
        See |vim.lsp.util.open_floating_preview| and |nvim_open_win|.
        Note that some options may be overridden by |open_floating_preview|.
      '';
    };

    status_text = {
      enabled = helpers.defaultNullOpts.mkBool false ''
        Status text.
        When enabled, will allow using |NvimLightbulb.get_status_text| to retrieve the configured text.
      '';

      text = helpers.defaultNullOpts.mkStr "💡" "Text to set if a lightbulb is available.";

      text_unavailable = helpers.defaultNullOpts.mkStr "" ''
        Text to set if a lightbulb is unavailable.
      '';
    };

    number = {
      enabled = helpers.defaultNullOpts.mkBool false "Number column.";

      hl = helpers.defaultNullOpts.mkStr "LightBulbNumber" ''
        Highlight group to highlight the number column if there is a lightbulb.
      '';
    };

    line = {
      enabled = helpers.defaultNullOpts.mkBool false "Content line.";

      hl = helpers.defaultNullOpts.mkStr "LightBulbLine" ''
        Highlight group to highlight the line if there is a lightbulb.
      '';
    };

    autocmd = {
      enabled = helpers.defaultNullOpts.mkBool false ''
        Autocmd configuration.
        If enabled, automatically defines an autocmd to show the lightbulb.
        If disabled, you will have to manually call |NvimLightbulb.update_lightbulb|.
        Only works if configured during `NvimLightbulb.setup`.
      '';

      updatetime = helpers.defaultNullOpts.mkInt 200 ''
        See |updatetime|.
        Set to a negative value to avoid setting the updatetime.
      '';

      pattern = helpers.defaultNullOpts.mkListOf types.str [ "*" ] ''
        See |nvim_create_autocmd| and |autocmd-pattern|.
      '';

      events =
        helpers.defaultNullOpts.mkListOf types.str
          [
            "CursorHold"
            "CursorHoldI"
          ]
          ''
            See |nvim_create_autocmd|.
          '';
    };

    ignore = {
      clients = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        LSP client names to ignore.
        Example: {"null-ls", "lua_ls"}
      '';

      ft = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        Filetypes to ignore.
        Example: {"neo-tree", "lua"}
      '';

      actions_without_kind = helpers.defaultNullOpts.mkBool false ''
        Ignore code actions without a `kind` like `refactor.rewrite`, quickfix.
      '';
    };
  };

  settingsExample = {
    sign = {
      enabled = false;
      text = "󰌶";
    };
    virtual_text = {
      enabled = true;
      text = "󰌶";
    };
    float = {
      enabled = false;
      text = " 󰌶 ";
      win_opts.border = "rounded";
    };
    status_text = {
      enabled = false;
      text = " 󰌶 ";
    };
    number = {
      enabled = false;
    };
    line = {
      enabled = false;
    };
    autocmd = {
      enabled = true;
      updatetime = 200;
    };
  };
}
