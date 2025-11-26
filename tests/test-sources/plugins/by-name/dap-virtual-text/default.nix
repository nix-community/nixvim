{
  empty = {
    plugins.dap.enable = true;
    plugins.dap-virtual-text.enable = true;
  };

  default = {
    plugins.dap.enable = true;
    plugins.dap-virtual-text = {
      enable = true;

      settings = {
        enabled_commands = true;
        highlight_changed_variables = true;
        highlight_new_as_changed = true;
        show_stop_reason = true;
        commented = false;
        only_first_definition = true;
        all_references = false;
        clear_on_continue = false;
        display_callback = ''
          function(variable, buf, stackframe, node, options)
            if options.virt_text_pos == 'inline' then
              return ' = ' .. variable.value
            else
              return variable.name .. ' = ' .. variable.value
            end
          end
        '';
        virt_text_pos = "eol";
        all_frames = false;
        virt_lines = false;
      };
    };
  };
}
