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
    enable_modules = {
      search = true;
      completion = true;
      cursor-actions = true;
      formatter = true;
      colors = true;
      base = true;
      debug = false;
    };
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
