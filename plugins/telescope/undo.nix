{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.telescope.extensions.undo;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.telescope.extensions.undo = {
    enable = mkEnableOption "undo";

    package = helpers.mkPackageOption "telescope extension undo" pkgs.vimPlugins.telescope-undo-nvim;

    useDelta = mkOption {
      type = types.nullOr types.bool;
      description = ''
        When set to true, [delta](https://github.com/dandavison/delta) is used for fancy diffs in the preview section.
        If set to false, `telescope-undo` will not use `delta` even when available and fall back to a plain diff with
        treesitter highlights.
      '';
      default = true;
    };

    useCustomCommand = mkOption {
      type = types.nullOr (types.listOf types.str);
      description = ''
        should be in this format: [ "bash" "-c" "echo '$DIFF' | delta" ]
      '';
      default = null;
    };

    sideBySide = mkOption {
      type = types.nullOr types.bool;
      description = ''
        If set to true tells `delta` to render diffs side-by-side. Thus, requires `delta` to be
        used. Be aware that `delta` always uses its own configuration, so it might be that you're getting
        the side-by-side view even if this is set to false.
      '';
      default = false;
    };

    diffContextLines = mkOption {
      type =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            either ints.unsigned str
        );
      description = ''Defaults to the scrolloff'';
      default = "vim.o.scrolloff";
    };

    entryFormat = mkOption {
      type = types.nullOr types.str;
      description = ''The format to show on telescope for the different versions of the file.'';
      default = "state #$ID, $STAT, $TIME";
    };

    timeFormat = mkOption {
      type = types.nullOr types.str;
      description = ''
        Can be set to a [Lua date format string](https://www.lua.org/pil/22.1.html).
      '';
      default = "";
    };

    mappings = {
      i =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf str
        )
        ''
          {
               "<cr>" = "yank_additions";
               "<s-cr>" = "yank_deletions";
               "<c-cr>" = "restore";
          }
        '';
      n =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf str
        )
        ''
           {
                 "y" = "yank_additions";
                 "Y" = "yank_deletions";
                 "u" = "restore";
          }
        '';
    };
  };

  config = let
    configuration = with cfg; {
      use_delta = useDelta;
      use_custom_command = useCustomCommand;
      side_by_side = sideBySide;
      diff_context_lines =
        if isInt diffContextLines
        then helpers.mkRaw "diffContextLines"
        else diffContextLines;
      entry_format = entryFormat;
      time_format = timeFormat;
      mappings = with mappings; {
        i =
          helpers.ifNonNull' i
          (mapAttrs
            (
              key: action:
                helpers.mkRaw "require('telescope-undo.actions').${action}"
            )
            mappings);

        n =
          helpers.ifNonNull' n
          (mapAttrs
            (
              key: action:
                helpers.mkRaw "require('telescope-undo.actions').${action}"
            )
            mappings);
      };
    };
  in
    mkIf
    cfg.enable
    {
      extraPlugins = [cfg.package];

      plugins.telescope.enabledExtensions = ["undo"];
      plugins.telescope.extensionConfig."undo" = configuration;
    };
}
