{
  empty = {
    plugins.dap.extensions.dap-virtual-text.enable = true;
  };

  default = {
    plugins.dap.extensions.dap-virtual-text = {
      enable = true;

      enabledCommands = true;
      highlightChangedVariables = true;
      highlightNewAsChanged = true;
      showStopReason = true;
      commented = false;
      onlyFirstDefinition = true;
      allReferences = false;
      clearOnContinue = false;
      displayCallback = ''
        function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value
          else
            return variable.name .. ' = ' .. variable.value
          end
        end
      '';
      virtTextPos = "eol";
      allFrames = false;
      virtLines = false;
    };
  };
}
