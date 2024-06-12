{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.rust = {
          enable = true;

          settings = {
            args = [ "--no-capture" ];
            dap_adapter = "lldb";
          };
        };
      };
    };
  };
}
