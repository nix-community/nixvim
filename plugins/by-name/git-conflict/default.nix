{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "git-conflict";
  package = "git-conflict-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  extraOptions = {
    gitPackage = lib.mkPackageOption pkgs "git" {
      nullable = true;
    };
  };

  extraConfig = cfg: { extraPackages = [ cfg.gitPackage ]; };

  settingsOptions = {
    default_mappings =
      helpers.defaultNullOpts.mkNullable (with types; either bool (attrsOf str)) true
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

    default_commands = helpers.defaultNullOpts.mkBool true ''
      Set to `false` to disable commands created by this plugin.
    '';

    disable_diagnostics = helpers.defaultNullOpts.mkBool false ''
      This will disable the diagnostics in a buffer whilst it is conflicted.
    '';

    list_opener = helpers.defaultNullOpts.mkStr "copen" ''
      Command or function to open the conflicts list.
    '';

    highlights = {
      incoming = helpers.defaultNullOpts.mkStr "DiffAdd" ''
        Which highlight group to use for incoming changes.
      '';

      current = helpers.defaultNullOpts.mkStr "DiffText" ''
        Which highlight group to use for current changes.
      '';

      ancestor = helpers.mkNullOrStr ''
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
