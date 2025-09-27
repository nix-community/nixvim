{
  lib,
  config,
  ...
}:
let
  inherit (lib) flatten mapAttrsToList mkRemovedOptionModule;
  inherit (lib.nixvim) mkDeprecatedSubOptionModule;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gitsigns";
  package = "gitsigns-nvim";
  description = "Git integration for buffers.";

  maintainers = [ lib.maintainers.GaetanLepage ];

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
      mkDeprecatedSubOptionModule optionPath "Please define the `${hlg}` highlight group instead."
    ) highlightRemovals)
    ++ [
      (mkRemovedOptionModule (
        basePluginPaths
        ++ [
          "watchGitDir"
          "interval"
        ]
      ) "The option has been removed from upstream.")
      (mkDeprecatedSubOptionModule (
        settingsPath
        ++ [
          "yadm"
          "enable"
        ]
      ) "yadm support was removed upstream.")

      # TODO: added 2025-04-06, remove after 25.05
      (lib.nixvim.mkRemovedPackageOptionModule {
        plugin = "gitsigns";
        packageName = "git";
      })
    ];

  dependencies = [ "git" ];

  settingsOptions = import ./settings-options.nix lib;

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
    warnings = lib.nixvim.mkWarnings "plugins.gitsigns" {
      when = (cfg.settings.trouble == true) && !config.plugins.trouble.enable;

      message = ''
        You have enabled `plugins.gitsigns.settings.trouble` but `plugins.trouble.enable` is `false`.
        You should maybe enable the `trouble` plugin.
      '';
    };
  };
}
