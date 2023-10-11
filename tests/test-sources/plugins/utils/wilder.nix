{
  empty = {
    plugins.wilder.enable = true;
  };

  example = {
    plugins.wilder = {
      enable = true;

      modes = ["/" ":"];
      enableCmdlineEnter = false;
      wildcharm = "k";
      nextKey = "a";
      prevKey = "b";
      acceptKey = "c";
      rejectKey = "d";
      acceptCompletionAutoSelect = false;
    };
  };
}
