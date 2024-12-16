lib:
[
  "maxSigns"
  {
    old = "showMessageOnHunkJumping";
    new = "show_msg_on_hunk_jumping";
  }
  {
    old = "defaultMaps";
    new = "map_keys";
  }
  {
    old = "allowClobberSigns";
    new = "sign_allow_clobber";
  }
  "signPriority"
  {
    old = "matchBackgrounds";
    new = "set_sign_backgrounds";
  }
  {
    old = "diffRelativeToWorkingTree";
    new = "diff_relative_to";
  }
  {
    old = "extraGitArgs";
    new = "git_args";
  }
  {
    old = "extraDiffArgs";
    new = "diff_args";
  }
  {
    old = "enableByDefault";
    new = "enabled";
  }
  {
    old = "signsByDefault";
    new = "signs";
  }
  "highlightLines"
  {
    old = "highlightLineNumbers";
    new = "highlight_linenrs";
  }
  {
    old = "runAsync";
    new = "async";
  }
  "previewWinFloating"
  "useLocationList"
  "terminalReportFocus"
]
++
  lib.mapAttrsToList
    (oldName: newName: {
      old = [
        "signs"
        oldName
      ];
      new = "sign_${newName}";
    })
    {
      added = "added";
      modified = "modified";
      removed = "removed";
      removedFirstLine = "removed_first_line";
      removedAboveAndBelow = "removed_above_and_below";
      modifiedRemoved = "modified_removed";
    }
