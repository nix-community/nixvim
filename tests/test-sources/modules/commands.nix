{
  example = {
    userCommands = {
      "W" = {
        command = ":w<CR>";
        desc = "Write file";
        nargs = 0;
      };
      "Z" = {
        command = ":echo fooo<CR>";
      };
      "InsertHere" = {
        command.__raw = ''
          function(opts)
            vim.api.nvim_put({opts.args}, 'c', true, true)
          end
        '';
        nargs = 1;
      };
    };
  };
}
