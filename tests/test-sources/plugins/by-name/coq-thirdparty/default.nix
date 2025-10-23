{
  empty = {
    plugins.coq-thirdparty.enable = true;
  };

  example = {
    plugins.coq-thirdparty = {
      enable = true;

      settings = [
        {
          src = "nvimlua";
          short_name = "nLUA";
        }
        {
          src = "vimtex";
          short_name = "vTEX";
        }
        { src = "demo"; }
      ];
    };
  };
}
