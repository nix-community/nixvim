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
  };

  settingsExample = {
    org_agenda_files = "~/orgfiles/**/*";
    org_default_notes_file = "~/orgfiles/refile.org";
  };
}
