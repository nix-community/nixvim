{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts mkNullOrStr;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "fugit2";
  packPathName = "fugit2.nvim";
  package = "fugit2-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    width = defaultNullOpts.mkNullable (with types; either str ints.unsigned) 100 ''
      Main popup width.
    '';

    max_width = defaultNullOpts.mkNullable (with types; either str ints.unsigned) "80%" ''
      Main popup width when expand patch view.
    '';

    min_width = defaultNullOpts.mkUnsignedInt 50 ''
      File view width when expand patch view.
    '';

    content_width = defaultNullOpts.mkUnsignedInt 60 ''
      File view content width.
    '';

    height = defaultNullOpts.mkNullable (with types; either str ints.unsigned) "60%" ''
      Main popup height.
    '';

    show_patch = defaultNullOpts.mkBool false ''
      Whether to show patch for active file when open `fugit2` main window.
    '';

    libgit2_path = mkNullOrStr ''
      Path to `libgit2` lib if not set via environments.
    '';

    gpgme_path = defaultNullOpts.mkStr "gpgme" ''
      Path to the `gpgme` lib.
    '';

    external_diffview = defaultNullOpts.mkBool false ''
      Whether to use external diffview.nvim or Fugit2 implementation.
    '';

    blame_priority = defaultNullOpts.mkUnsignedInt 1 ''
      Priority of blame virtual text.
    '';

    blame_info_width = defaultNullOpts.mkUnsignedInt 60 ''
      Width of blame hunk detail popup.
    '';

    blame_info_height = defaultNullOpts.mkUnsignedInt 10 ''
      Height of blame hunk detail popup.
    '';

    colorscheme = mkNullOrStr ''
      Custom colorscheme specification.
    '';
  };

  settingsExample = {
    width = "62%";
    height = "90%";
    external_diffview = true;
  };
}
