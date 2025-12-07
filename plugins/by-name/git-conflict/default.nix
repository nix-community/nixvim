{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "git-conflict";
  package = "git-conflict-nvim";
  description = "A plugin to visualise and resolve merge conflicts in neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "git" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "git-conflict";
      packageName = "git";
    })
  ];

  settingsOptions = {
    default_mappings =
      lib.nixvim.defaultNullOpts.mkNullable (with lib.types; either bool (attrsOf str)) true
        ''
          This plugin offers default buffer local mappings inside conflicted files.
          This is primarily because applying these mappings only to relevant buffers is impossible
          through global mappings.

          Set to `false` to disable mappings entirely.

          Defaults (if left `true`):
          ```nix
            {
              ours = "co";
              theirs = "ct";
              none = "c0";
              both = "cb";
              next = "[x";
              prev = "]x";
            }
          ```
        '';

    default_commands = lib.nixvim.defaultNullOpts.mkBool true ''
      Set to `false` to disable commands created by this plugin.
    '';

    disable_diagnostics = lib.nixvim.defaultNullOpts.mkBool false ''
      This will disable the diagnostics in a buffer whilst it is conflicted.
    '';

    list_opener = lib.nixvim.defaultNullOpts.mkStr "copen" ''
      Command or function to open the conflicts list.
    '';

    highlights = {
      incoming = lib.nixvim.defaultNullOpts.mkStr "DiffAdd" ''
        Which highlight group to use for incoming changes.
      '';

      current = lib.nixvim.defaultNullOpts.mkStr "DiffText" ''
        Which highlight group to use for current changes.
      '';

      ancestor = lib.nixvim.mkNullOrStr ''
        Which highlight group to use for ancestor.

        Plugin default: `null`
      '';
    };
  };

  settingsExample = {
    default_mappings = {
      ours = "o";
      theirs = "t";
      none = "0";
      both = "b";
      next = "n";
      prev = "p";
    };
    default_commands = true;
    disable_diagnostics = false;
    list_opener = "copen";
    highlights = {
      incoming = "DiffAdd";
      current = "DiffText";
    };
  };
}
