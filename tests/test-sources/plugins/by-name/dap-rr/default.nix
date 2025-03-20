{
  empty = {
    plugins = {
      dap.enable = true;
      dap-rr.enable = true;
    };
  };

  defaults = {
    plugins = {
      dap.enable = true;
      dap-rr = {
        enable = true;

        settings = {
          mappings = {
            continue = "<F7>";
            step_over = "<F8>";
            step_out = "<F9>";
            step_into = "<F10>";
            reverse_continue = "<F19>";
            reverse_step_over = "<F20>";
            reverse_step_out = "<F21>";
            reverse_step_into = "<F22>";
            step_over_i = "<F32>";
            step_out_i = "<F33>";
            step_into_i = "<F34>";
            reverse_step_over_i = "<F44>";
            reverse_step_out_i = "<F45>";
            reverse_step_into_i = "<F46>";
          };
        };
      };
    };
  };

  example = {
    plugins = {
      dap.enable = true;
      dap-rr = {
        enable = true;

        settings = {
          mappings = {
            continue = "<f4>";
            step_over = "<f10>";
            step_out = "<f8>";
            step_into = "<f11>";
            reverse_continue = "<f4>";
            reverse_step_over = "<s-f10>";
            reverse_step_out = "<s-f8>";
            reverse_step_into = "<s-f11>";
          };
        };
      };
    };
  };
}
