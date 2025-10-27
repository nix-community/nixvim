{
  empty = {
    plugins.vimux.enable = true;
  };

  defaults = {
    plugins.vimux = {
      enable = true;

      settings = {
        Height = "20%";
        Orientation = "v";
        UseNearest = 1;
        ResetSequence = "C-u";
        PromptString = "Command? ";
        RunnerType = "pane";
        RunnerName = "";
        TmuxCommand = "tmux";
        OpenExtraArgs = "";
        ExpandCommand = 0;
        CloseOnExit = 0;
        CommandShell = 1;
        RunnerQuery.__empty = { };
        Debug = false;
      };
    };
  };

  example = {
    plugins.vimux = {
      enable = true;

      settings = {
        Height = "25";
        Orientation = "h";
        UseNearest = 0;
      };
    };
  };
}
