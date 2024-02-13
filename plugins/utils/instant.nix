{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
  mkVimPlugin config {
    name = "instant";
    originalName = "instant.nvim";
    package = pkgs.vimPlugins.instant-nvim;
    globalPrefix = "instant_";
    addExtraConfigRenameWarning = true;

    options = let
      mkStr = global: default: desc:
        mkDefaultOpt {
          inherit global;
          type = types.str;
          description = ''
            ${desc}

            Default: ${default}
          '';
        };
    in {
      username = mkDefaultOpt {
        type = types.str;
        description = ''
          Username.
          Explicitly set to `null` if you do not want this option to be set.
        '';
      };

      onlyCwd = mkDefaultOpt {
        type = types.bool;
        description = ''
          Choose whether to share files only in the current working directory in session mode.

          Default: `true`
        '';
      };

      cursorHlGroupUser1 = mkStr "cursor_hl_group_user_1" "Cursor" ''
        Cursor highlight group for user 1.
      '';

      cursorHlGroupUser2 = mkStr "cursor_hl_group_user_2" "Cursor" ''
        Cursor highlight group for user 2.
      '';

      cursorHlGroupUser3 = mkStr "cursor_hl_group_user_3" "Cursor" ''
        Cursor highlight group for user 3.
      '';

      cursorHlGroupUser4 = mkStr "cursor_hl_group_user_4" "Cursor" ''
        Cursor highlight group for user 4.
      '';

      cursorHlGroupDefault = mkStr "cursor_hl_group_default" "Cursor" ''
        Cursor highlight group for any other userr.
      '';

      nameHlGroupUser1 = mkStr "name_hl_group_user_1" "CursorLineNr" ''
        Virtual text highlight group for user 1.
      '';

      nameHlGroupUser2 = mkStr "name_hl_group_user_2" "CursorLineNr" ''
        Virtual text highlight group for user 2.
      '';

      nameHlGroupUser3 = mkStr "name_hl_group_user_3" "CursorLineNr" ''
        Virtual text highlight group for user 3.
      '';

      nameHlGroupUser4 = mkStr "name_hl_group_user_4" "CursorLineNr" ''
        Virtual text highlight group for user 4.
      '';

      nameHlGroupDefault = mkStr "name_hl_group_default" "CursorLineNr" ''
        Virtual text highlight group for any other user.
      '';
    };
  }
