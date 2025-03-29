{ lib, pkgs, ... }:
let
  name = "papis";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;
  packPathName = "papis.nvim";
  package = "papis-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports = [
    # papis.nvim is an nvim-cmp source too
    (lib.nixvim.modules.mkCmpPluginModule {
      pluginName = name;
      sourceName = name;
    })
  ];

  extraOptions = {
    yqPackage = lib.mkPackageOption pkgs "yq" {
      nullable = true;
    };
  };
  extraConfig = cfg: {
    extraPackages = [ cfg.yqPackage ];
  };

  settingsOptions = import ./settings-options.nix lib;

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
