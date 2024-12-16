{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "gitsigns";
  packPathName = "gitsigns.nvim";
  package = "gitsigns-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO: introduced 2024-03-12, remove on 2024-05-12
  deprecateExtraOptions = true;
  optionsRenamedToSettings = import ./renamed-options.nix;
  imports =
    let
      basePluginPaths = [
        "plugins"
        "gitsigns"
      ];
      settingsPath = basePluginPaths ++ [ "settings" ];

      highlights = {
        add = "Add";
        change = "Change";
        delete = "Delete";
        topdelete = "Topdelete";
        changedelete = "Changedelete";
        untracked = "Untracked";
      };

      subHighlights = {
        hl = "";
        linehl = "Ln";
        numhl = "Nr";
      };

      highlightRemovals = flatten (
        mapAttrsToList (
          opt: hlg:
          mapAttrsToList (subOpt: subHlg: {
            optionPath = settingsPath ++ [
              "signs"
              opt
              subOpt
            ];
            hlg = "GitSigns${hlg}${subHlg}";
          }) subHighlights
        ) highlights
      );
    in
    (map (
      { optionPath, hlg }:
      helpers.mkDeprecatedSubOptionModule optionPath "Please define the `${hlg}` highlight group instead."
    ) highlightRemovals)
    ++ [
      (mkRemovedOptionModule (
        basePluginPaths
        ++ [
          "watchGitDir"
          "interval"
        ]
      ) "The option has been removed from upstream.")
      (helpers.mkDeprecatedSubOptionModule (
        settingsPath
        ++ [
          "yadm"
          "enable"
        ]
      ) "yadm support was removed upstream.")
    ];

  extraOptions = {
    gitPackage = lib.mkPackageOption pkgs "git" {
      nullable = true;
    };
  };

  settingsOptions = import ./options.nix { inherit lib helpers; };

  settingsExample = {
    signs = {
      add.text = "│";
      change.text = "│";
      delete.text = "_";
      topdelete.text = "‾";
      changedelete.text = "~";
      untracked.text = "┆";
    };
    signcolumn = true;
    watch_gitdir.follow_files = true;
    current_line_blame = false;
    current_line_blame_opts = {
      virt_text = true;
      virt_text_pos = "eol";
    };
  };

  extraConfig = cfg: {
    warnings =
      optional ((isBool cfg.settings.trouble && cfg.settings.trouble) && !config.plugins.trouble.enable)
        ''
          Nixvim (plugins.gitsigns): You have enabled `plugins.gitsigns.settings.trouble` but
          `plugins.trouble.enable` is `false`.
          You should maybe enable the `trouble` plugin.
        '';
    extraPackages = [ cfg.gitPackage ];
  };
}
