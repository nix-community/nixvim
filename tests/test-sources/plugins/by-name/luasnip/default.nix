{
  empty = {
    plugins.luasnip.enable = true;
  };

  example = {
    plugins.luasnip = {
      enable = true;

      settings = {
        history = true;
        updateevents = "TextChanged,TextChangedI";
        enable_autosnippets = true;
        ext_opts = {
          "__rawKey__require('luasnip.util.types').choiceNode".active.virt_text = [
            [
              "●"
              "GruvboxOrange"
            ]
          ];
          "__rawKey__require('luasnip.util.types').insertNode".active.virt_text = [
            [
              "●"
              "GruvboxBlue"
            ]
          ];
        };
      };
    };
  };
}
