{
  config,
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-virtual-text";
  moduleName = "nvim-dap-virtual-text";
  package = "nvim-dap-virtual-text";
  description = "A plugin that adds virtual text support to the nvim-dap.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    enabled_commands = defaultNullOpts.mkBool true ''
      Create commands `DapVirtualTextEnable`, `DapVirtualTextDisable`, `DapVirtualTextToggle`.

      (`DapVirtualTextForceRefresh` for refreshing when debug adapter did not notify its termination).
    '';

    highlight_changed_variables = defaultNullOpts.mkBool true ''
      Highlight changed values with `NvimDapVirtualTextChanged`, else always `NvimDapVirtualText`.
    '';

    highlight_new_as_changed = defaultNullOpts.mkBool false ''
      Highlight new variables in the same way as changed variables (if highlight_changed_variables).
    '';

    show_stop_reason = defaultNullOpts.mkBool true "Show stop reason when stopped for exceptions.";

    commented = defaultNullOpts.mkBool false "Prefix virtual text with comment string.";

    only_first_definition = defaultNullOpts.mkBool true "Only show virtual text at first definition (if there are multiple).";

    all_references = defaultNullOpts.mkBool false "Show virtual text on all references of the variable (not only definitions).";

    clear_on_continue = defaultNullOpts.mkBool false "Clear virtual text on `continue` (might cause flickering when stepping).";

    display_callback = defaultNullOpts.mkLuaFn ''
      function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value
        else
          return variable.name .. ' = ' .. variable.value
        end
      end,
    '' "A callback that determines how a variable is displayed or whether it should be omitted.";

    virt_text_pos = defaultNullOpts.mkStr "vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol'" ''
      Position of virtual text, see `:h nvim_buf_set_extmark()`.
      Default tries to inline the virtual text. Use 'eol' to set to end of line.
    '';

    all_frames = defaultNullOpts.mkBool false "Show virtual text for all stack frames not only current.";

    virt_lines = defaultNullOpts.mkBool false "Show virtual lines instead of virtual text (will flicker!).";

    virt_text_win_col = lib.nixvim.mkNullOrOption lib.types.int ''
      Position the virtual text at a fixed window column (starting from the first text column).
      See `:h nvim_buf_set_extmark()`.
    '';
  };

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.dap-virtual-text" {
      assertion = config.plugins.dap.enable;
      message = ''
        You have to enable `plugins.dap` to use `plugins.dap-virtual-text`.
      '';
    };
  };

  # NOTE: Renames added in https://github.com/nix-community/nixvim/pull/2897 (2025-01-26)
  imports = [ ./deprecations.nix ];
}
