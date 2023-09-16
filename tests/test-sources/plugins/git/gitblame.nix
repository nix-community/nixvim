{
  empty = {
    plugins.gitblame.enable = true;
  };

  defaults = {
    plugins.gitblame = {
      enable = true;
      messageTemplate = "<author> • <date> • <summary>";
      dateFormat = "%c";
      messageWhenNotCommitted = "Not Committed Yet";
      highlightGroup = "Comment";
      enableVirtualText = true;
      delay = 0;
      virtualTextColumn = null;
      extmarkOptions = null;
    };
  };
}
