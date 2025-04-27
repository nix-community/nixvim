{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neogit";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-02-29: remove 2024-04-29
  deprecateExtraOptions = true;
  imports =
    [
      # TODO: added 2025-04-07, remove after 25.05
      (lib.nixvim.mkRemovedPackageOptionModule {
        plugin = "neogit";
        packageName = "git";
      })
      (lib.nixvim.mkRemovedPackageOptionModule {
        plugin = "neogit";
        packageName = "which";
      })
    ]
    ++ (map
      (
        optionPath:
        mkRemovedOptionModule
          (
            [
              "plugins"
              "neogit"
            ]
            ++ optionPath
          )
          "This option has been removed upstream. Please refer to the plugin documentation to update your configuration."
      )
      [
        [ "disableCommitConfirmation" ]
        [ "disableBuiltinNotifications" ]
        [ "useMagitKeybindings " ]
        [ "commitPopup" ]
        [
          "sections"
          "unmerged"
        ]
        [
          "sections"
          "unpulled"
        ]
      ]
    );
  optionsRenamedToSettings = [
    "disableSigns"
    "disableHint"
    "disableContextHighlighting"
    "autoRefresh"
    "graphStyle"
    "kind"
    "signs"
    "integrations"
    [
      "sections"
      "untracked"
    ]
    [
      "sections"
      "unstaged"
    ]
    [
      "sections"
      "staged"
    ]
    [
      "sections"
      "stashes"
    ]
    [
      "sections"
      "recent"
    ]
    "mappings"
  ];

  dependencies = [
    "git"
    {
      name = "which";
      enable = hasInfix "which" (config.plugins.neogit.settings.commit_view.verify_commit.__raw or "");
    }
  ];

  settingsOptions = import ./settings-options.nix { inherit lib helpers; };

  settingsExample = {
    kind = "floating";
    commit_popup.kind = "floating";
    preview_buffer.kind = "floating";
    popup.kind = "floating";
    integrations.diffview = false;
    disable_commit_confirmation = true;
    disable_builtin_notifications = true;
    sections = {
      untracked.folded = false;
      unstaged.folded = false;
      staged.folded = false;
      stashes.folded = false;
      unpulled.folded = false;
      unmerged.folded = true;
      recent.folded = true;
    };
    mappings = {
      status = {
        l = "Toggle";
        a = "Stage";
      };
    };
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.neogit" (
      map
        (name: {
          assertion =
            let
              extensionEnabled = cfg.settings.integrations.${name} == true;
              pluginEnabled = config.plugins.${name}.enable;
            in
            extensionEnabled -> pluginEnabled;

          message = ''
            You have enabled the `${name}` integration, but `plugins.${name}.enable` is `false`.
          '';
        })
        [
          "telescope"
          "diffview"
          "fzf-lua"
        ]
    );
  };
}
