{
  lib,
  ...
}:
{
  empty = {
    plugins.leap.enable = true;
  };

  # https://github.com/nix-community/nixvim/issues/1698
  autojump-disabled = {
    plugins.leap = {
      enable = true;
      settings.safe_labels.__empty = null;
    };
  };

  example = {
    plugins.leap = {
      enable = true;
      settings = {
        max_phase_one_targets = 10;
        highlight_unlabeled_phase_one_targets = false;
        max_highlighted_traversal_targets = 10;
        case_sensitive = false;
        equivalence_classes = [ " \t\r\n" ];
        substitute_chars = {
          "\r" = "¬";
        };
        safe_labels = lib.stringToCharacters "sfnut/SFNLHMUGT?Z";
        labels = lib.stringToCharacters "sfnjklhodwembuyvrgtcx/zSFNJKLHODWEMBUYVRGTCX?Z";
        special_keys = {
          next_target = "<enter>";
          prev_target = "<tab>";
          next_group = "<space>";
          prev_group = "<tab>";
          multi_accept = "<enter>";
          multi_revert = "<backspace>";
        };
      };
    };
  };
}
