{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "papis";
  packPathName = "papis.nvim";
  package = "papis-nvim";
  description = "Manage your bibliography from within your favourite editor.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # papis.nvim is an nvim-cmp source too
  imports = [
    { cmpSourcePlugins.papis = "papis"; }

    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "yq";
      packageName = "yq";
    })
  ];

  dependencies = [ "yq" ];

  settingsExample = {
    enable_keymaps = true;
    papis_python = {
      dir = "~/Documents/papers";
      info_name = "info.yaml";
      notes_name.__raw = "[[notes.norg]]";
    };

    search.enable = true;
    completion.enable = true;
    cursor-actions.enable = true;
    formatter.enable = true;
    colors.enable = true;
    base.enable = true;
    debug.enable = true;
    cite_formats = {
      tex = [
        "\\cite{%s}"
        "\\cite[tp]?%*?{%s}"
      ];
      markdown = "@%s";
      rmd = "@%s";
      plain = "%s";
      org = [
        "[cite:@%s]"
        "%[cite:@%s]"
      ];
      norg = "{= %s}";
    };
  };
}
