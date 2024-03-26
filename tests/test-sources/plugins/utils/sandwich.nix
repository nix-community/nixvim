{
  empty = {
    plugins.sandwich.enable = true;
  };

  example = {
    plugins.sandwich = {
      enable = true;

      settings = {
        no_default_key_mappings = true;
        no_tex_ftplugin = true;
        no_vim_ftplugin = true;
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
