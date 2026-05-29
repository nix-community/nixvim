{
  empty = {
    plugins = {
      treesitter.enable = true;
      wildfire.enable = true;
    };
  };

  defaults = {
    plugins = {
      treesitter.enable = true;
      wildfire = {
        enable = true;
        settings = {
          surrounds = [
            [
              "("
              ")"
            ]
            [
              "{"
              "}"
            ]
            [
              "<"
              ">"
            ]
            [
              "["
              "]"
            ]
          ];
          keymaps = {
            init_selection = "<CR>";
            node_incremental = "<CR>";
            node_decremental = "<BS>";
          };
          filetype_exclude = [ "qf" ];
        };
      };
    };
  };
}
