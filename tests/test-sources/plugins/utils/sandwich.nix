{
  empty = {
    plugins.sandwich.enable = true;
  };

  example = {
    plugins.sandwich = {
      enable = true;

      settings = {
        no_default_key_mappings = 1;
        no_tex_ftplugin = 1;
        no_vim_ftplugin = 1;
      };
    };

    globals."sandwich#magicchar#f#patterns" = [
      {
        header.__raw = "[[\<\%(\h\k*\.\)*\h\k*]]";
        bra = "(";
        ket = ")";
        footer = "";
      }
    ];
  };
}
