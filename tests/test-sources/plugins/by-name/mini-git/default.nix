{
  empty = {
    plugins.mini-git.enable = true;
  };

  example = {
    plugins.mini-git = {
      enable = true;
      settings = {
        job.timeout = 20000;
        command.split = "horizontal";
      };
    };
  };
}
