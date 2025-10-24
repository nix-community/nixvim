{
  empty = {
    # stderr is not empty:
    #     last 1 log lines:
    # > ERROR:   /build/build/wiki is created.
    test.runNvim = false;

    plugins.kiwi.enable = true;
  };

  example = {
    # stderr is not empty:
    #        last 2 log lines:
    # > ERROR:   /build/work-wiki is created.
    # >   /build/personal-wiki is created.
    test.runNvim = false;

    plugins.kiwi = {
      enable = true;

      settings = [
        {
          name = "work";
          path = "work-wiki";
        }
        {
          name = "personal";
          path = "personal-wiki";
        }
      ];
    };
  };
}
