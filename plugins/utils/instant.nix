{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; {
  options.plugins.instant = {
    enable = mkEnableOption "instant.nvim";

    package = helpers.mkPackageOption "instant" pkgs.vimPlugins.instant-nvim;

    username = mkOption {
      type = with types; nullOr str;
      description = ''
        Username.
        Explicitly set to `null` if you do not want this option to be set.
      '';
    };

    onlyCwd = helpers.defaultNullOpts.mkBool true ''
      Choose whether to share files only in the current working directory in session mode.
    '';

    cursorHlGroupUser1 = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for user 1.
    '';

    cursorHlGroupUser2 = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for user 2.
    '';

    cursorHlGroupUser3 = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for user 3.
    '';

    cursorHlGroupUser4 = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for user 4.
    '';

    cursorHlGroupDefault = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for any other userr.
    '';

    nameHlGroupUser1 = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for user 1.
    '';

    nameHlGroupUser2 = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for user 2.
    '';

    nameHlGroupUser3 = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for user 3.
    '';

    nameHlGroupUser4 = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for user 4.
    '';

    nameHlGroupDefault = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for any other user.
    '';

    extraOptions = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Extra configuration options for instant without the 'instant_' prefix.
        Example: To set 'instant_foobar' to 1, write
        ```nix
          extraConfig = {
            foobar = true;
          };
        ```
      '';
    };
  };

  config = let
    cfg = config.plugins.instant;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      globals =
        mapAttrs'
        (name: nameValuePair ("instant_" + name))
        (
          with cfg;
            {
              inherit username;
              only_cwd = onlyCwd;
              cursor_hl_group_user_1 = cursorHlGroupUser1;
              cursor_hl_group_user_2 = cursorHlGroupUser2;
              cursor_hl_group_user_3 = cursorHlGroupUser3;
              cursor_hl_group_user_4 = cursorHlGroupUser4;
              cursor_hl_group_default = cursorHlGroupDefault;
              name_hl_group_user_1 = nameHlGroupUser1;
              name_hl_group_user_2 = nameHlGroupUser2;
              name_hl_group_user_3 = nameHlGroupUser3;
              name_hl_group_user_4 = nameHlGroupUser4;
              name_hl_group_default = nameHlGroupDefault;
            }
            // extraOptions
        );
    };
}
