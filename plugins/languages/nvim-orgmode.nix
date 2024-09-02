{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin config {
  name = "orgmode";
  originalName = "nvim-orgmode";
  defaultPackage = pkgs.vimPlugins.orgmode;

  maintainers = [ lib.nixvim.maintainers.refaelsh ];

  settingsOptions = {
    org_agenda_files = defaultNullOpts.mkNullable (with lib.types; either str (listOf str)) "" ''
      A path for Org agenda files.
    '';
    org_default_notes_file = defaultNullOpts.mkStr "" ''
      A path to the default notes file.
    '';
    org_startup_indented = defaultNullOpts.mkBool false ''
      When set to true, uses Virtual indents to align content visually.
      The indents are only visual, they are not saved to the file.
      When set to false, does not add any Virtual indentation.
    '';
  };

  settingsExample = {
    org_agenda_files = "~/orgfiles/**/*";
    org_default_notes_file = "~/orgfiles/refile.org";
    org_startup_indented = true;
  };
}
