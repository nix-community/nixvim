{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;

  cfg = config.plugins.dap.extensions.dap-virtual-text;
in
{
  options.plugins.dap.extensions.dap-virtual-text = {
    enable = lib.mkEnableOption "dap-virtual-text";

    package = lib.mkPackageOption pkgs "dap-virtual-text" {
      default = [
        "vimPlugins"
        "nvim-dap-virtual-text"
      ];
    };

    enabledCommands = defaultNullOpts.mkBool true ''
      Create commands `DapVirtualTextEnable`, `DapVirtualTextDisable`, `DapVirtualTextToggle`.
      (`DapVirtualTextForceRefresh` for refreshing when debug adapter did not notify its termination).
    '';

    highlightChangedVariables = defaultNullOpts.mkBool true ''
      Highlight changed values with `NvimDapVirtualTextChanged`, else always `NvimDapVirtualText`.
    '';

    highlightNewAsChanged = defaultNullOpts.mkBool false ''
      Highlight new variables in the same way as changed variables (if highlightChangedVariables).
    '';

    showStopReason = defaultNullOpts.mkBool true "Show stop reason when stopped for exceptions.";

    commented = defaultNullOpts.mkBool false "Prefix virtual text with comment string.";

    onlyFirstDefinition = defaultNullOpts.mkBool true "Only show virtual text at first definition (if there are multiple).";

    allReferences = defaultNullOpts.mkBool false "Show virtual text on all all references of the variable (not only definitions).";

    clearOnContinue = defaultNullOpts.mkBool false "Clear virtual text on `continue` (might cause flickering when stepping).";

    displayCallback = defaultNullOpts.mkLuaFn ''
      function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value
        else
          return variable.name .. ' = ' .. variable.value
        end
      end,
    '' "A callback that determines how a variable is displayed or whether it should be omitted.";

    virtTextPos = defaultNullOpts.mkStr "vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol'" ''
      Position of virtual text, see `:h nvim_buf_set_extmark()`.
      Default tries to inline the virtual text. Use 'eol' to set to end of line.
    '';

    allFrames = defaultNullOpts.mkBool false "Show virtual text for all stack frames not only current.";

    virtLines = defaultNullOpts.mkBool false "Show virtual lines instead of virtual text (will flicker!).";

    virtTextWinCol = lib.nixvim.mkNullOrOption lib.types.int ''
      Position the virtual text at a fixed window column (starting from the first text column).
      See `:h nvim_buf_set_extmark()`.
    '';
  };

  config =
    let
      options = with cfg; {
        inherit commented;

        enabled_commands = enabledCommands;
        highlight_changed_variables = highlightChangedVariables;
        highlight_new_as_changed = highlightNewAsChanged;
        show_stop_reason = showStopReason;
        only_first_definition = onlyFirstDefinition;
        all_references = allReferences;
        clear_on_continue = clearOnContinue;
        display_callback = displayCallback;
        virt_text_pos = virtTextPos;
        all_frames = allFrames;
        virt_lines = virtLines;
        virt_text_win_col = virtTextWinCol;
      };
    in
    lib.mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      plugins.dap = {
        enable = true;

        extensionConfigLua = ''
          require("nvim-dap-virtual-text").setup(${lib.nixvim.toLuaObject options});
        '';
      };
    };
}
