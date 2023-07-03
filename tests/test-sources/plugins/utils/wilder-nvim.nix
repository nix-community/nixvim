{
  empty = {
    plugins.wilder-nvim.enable = true;
  };

  example = {
    plugins.wilder-nvim = {
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
