{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "orgmode";
  packPathName = "nvim-orgmode";
  description = "Nvim orgmode is a clone of Emacs Orgmode for Neovim.";

  maintainers = [ lib.maintainers.refaelsh ];

  settingsOptions = {
    org_agenda_files = defaultNullOpts.mkNullable (with lib.types; either str (listOf str)) "" ''
      A path for Org agenda files.
    '';
    org_default_notes_file = defaultNullOpts.mkStr "" ''
      A path to the default notes file.
    '';
  };

  settingsExample = {
    org_agenda_files = "~/orgfiles/**/*";
    org_default_notes_file = "~/orgfiles/refile.org";
  };
}
