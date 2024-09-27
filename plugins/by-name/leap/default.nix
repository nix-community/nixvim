{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.leap;
in
{
  options.plugins.leap = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "leap.nvim";

    package = lib.mkPackageOption pkgs "leap.nvim" {
      default = [
        "vimPlugins"
        "leap-nvim"
      ];
    };

    addDefaultMappings = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the default mappings.";
    };

    maxPhaseOneTargets = helpers.mkNullOrOption types.int ''
      By default, the plugin shows labels and/or highlights matches right after the first input
      character.
      This option disables ahead-of-time displaying of target beacons beyond a certain number of
      phase one targets (to mitigate visual noise in extreme cases).
      Setting it to 0 disables two-phase processing altogether.
    '';

    highlightUnlabeledPhaseOneTargets = helpers.defaultNullOpts.mkBool false ''
      Whether to highlight unlabeled (i.e., directly reachable) matches after the first input
      character.
    '';

    maxHighlightedTraversalTargets = helpers.defaultNullOpts.mkInt 10 ''
      Number of targets to be highlighted after the cursor in `|leap-traversal|` mode (when there
      are no labels at all).
    '';

    caseSensitive = helpers.defaultNullOpts.mkBool false ''
      Whether to consider case in search patterns.
    '';

    equivalenceClasses = helpers.defaultNullOpts.mkListOf' {
      type = with types; either str (listOf str);
      description = ''
        A character will match any other in its equivalence class. The sets can
        either be defined as strings or tables.

        Note: Make sure to have a set containing `\n` if you want to be able to
        target characters at the end of the line.

        Note: Non-mutual aliases are not possible in Leap, for the same reason
        that supporting |smartcase| is not possible: we would need to show two
        different labels, corresponding to two different futures, at the same
        time.
      '';
      pluginDefault = [ " \t\r\n" ];
      example = [
        "\r\n"
        ")]}>"
        "([{<"
        [
          "\""
          "'"
          "`"
        ]
      ];
    };

    substituteChars = helpers.defaultNullOpts.mkAttrsOf' {
      type = types.str;
      description = ''
        The keys in this attrs will be substituted in labels and highlighted matches by the given
        characters.
        This way special (e.g. whitespace) characters can be made visible in matches, or even be
        used as labels.
      '';
      pluginDefault = { };
      example = {
        "\r" = "¬";
      };
    };

    safeLabels =
      helpers.defaultNullOpts.mkNullable (with lib.types; maybeRaw (listOf str))
        (stringToCharacters "sfnut/SFNLHMUGT?Z")
        ''
          When the number of matches does not exceed the number of these "safe" labels plus one, the
          plugin jumps to the first match automatically after entering the pattern.
          Obviously, for this purpose you should choose keys that are unlikely to be used right
          after a jump!

          Setting the list to `[]` effectively disables the autojump feature.

          Note: Operator-pending mode ignores this, since we need to be able to select the actual
          target before executing the operation.
        '';

    labels =
      helpers.defaultNullOpts.mkListOf types.str
        (stringToCharacters "sfnjklhodwembuyvrgtcx/zSFNJKLHODWEMBUYVRGTCX?Z")
        ''
          Target labels to be used when there are more matches than labels in
          `|leap.opts.safe_labels|` plus one.

          Setting the list to `[]` forces autojump to always be on (except for Operator-pending
          mode, where it makes no sense).
          In this case, do not forget to set `special_keys.next_group` to something "safe" too.
        '';

    specialKeys = {
      nextTarget = helpers.defaultNullOpts.mkStr "<enter>" ''
        Key captured by the plugin at runtime to jump to the next match in traversal mode
        (`|leap-traversal|`)
      '';

      prevTarget = helpers.defaultNullOpts.mkStr "<tab>" ''
        Key captured by the plugin at runtime to jump to the previous match in traversal mode
        (`|leap-traversal|`)
      '';

      nextGroup = helpers.defaultNullOpts.mkStr "<space>" ''
        Key captured by the plugin at runtime to switch to the next group of matches, when there
        are more matches than available labels.
      '';

      prevGroup = helpers.defaultNullOpts.mkStr "<tab>" ''
        Key captured by the plugin at runtime to switch to the previous group of matches, when
        there are more matches than available labels.
      '';

      multiAccept = helpers.defaultNullOpts.mkStr "<enter>" ''
        Key captured by the plugin at runtime to accept the selection in `|leap-multiselect|`
        mode.
      '';

      multiRevert = helpers.defaultNullOpts.mkStr "<backspace>" ''
        Key captured by the plugin at runtime to deselect the last selected target in
        `|leap-multiselect|` mode.
      '';
    };
  };

  config =
    let
      options =
        with cfg;
        {
          max_phase_one_targets = maxPhaseOneTargets;
          highlight_unlabeled_phase_one_targets = highlightUnlabeledPhaseOneTargets;
          max_highlighted_traversal_targets = maxHighlightedTraversalTargets;
          case_sensitive = caseSensitive;
          equivalence_classes = equivalenceClasses;
          substitute_chars = substituteChars;
          safe_labels = safeLabels;
          inherit labels;
          special_keys = with specialKeys; {
            next_target = nextTarget;
            prev_target = prevTarget;
            next_group = nextGroup;
            prev_group = prevGroup;
            multi_accept = multiAccept;
            multi_revert = multiRevert;
          };
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua =
        (optionalString cfg.addDefaultMappings ''
          require('leap').add_default_mappings()
        '')
        + (optionalString (options != { }) ''
          require('leap').opts = vim.tbl_deep_extend(
            "keep",
            ${helpers.toLuaObject options},
            require('leap').opts
          )
        '');
    };
}
