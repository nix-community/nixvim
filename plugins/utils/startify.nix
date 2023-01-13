{ pkgs, lib, ... }@args:
let
  helpers = import ../helpers.nix { lib = lib; };
in with lib; with helpers;
mkPlugin args {
  name = "startify";
  description = "Enable startify";
  extraPlugins = [ pkgs.vimPlugins.vim-startify ];

  options = {
    sessionDir = mkDefaultOpt {
      description = "Directory to save/load session";
      global = "startify_session_dir";
      type = types.str;
    };

    lists = mkDefaultOpt {
      description = "Startify display lists. If it's a string, it'll be interpreted as literal lua code";
      global = "startify_lists";
      type = types.listOf (types.oneOf [(types.submodule {
        options = {
          type = mkOption {
            type = types.str;
            description = "The type of the list";
          };
          # TODO the header should be a literal lua string!
          header = mkOption {
            type = types.nullOr (types.listOf types.str);
            description = "Optional header. It's a list of strings";
            default = null;
          };
          indices = mkOption {
            type = types.nullOr (types.listOf types.str);
            description = "Optional indices for the current list";
            default = null;
          };
        };
      }) types.str]);

      value = val: let
        list = map (v: if builtins.isAttrs v then toLuaObject v else v) val;
      in "{" + (concatStringsSep "," list) + "}";
    };

    bookmarks = mkDefaultOpt {
      description = "A list of files or directories to bookmark.";
      global = "startify_bookmarks";
      type = with types; listOf (oneOf [str (attrsOf str)]);
    };

    commands = mkDefaultOpt {
      description = "A list of commands to execute on selection";
      global = "startify_commands";
      type = with types; listOf (oneOf [ str (listOf str) attrs ]);
    };

    filesNumber = mkDefaultOpt {
      description = "The number of files to list";
      global = "startify_files_number";
      type = types.int;
    };

    updateOldFiles = mkDefaultOpt {
      description = "Update v:oldfiles on-the-fly, so that :Startify is always up-to-date";
      global = "startify_update_oldfiles";
      type = types.bool;
    };

    sessionAutoload = mkDefaultOpt {
      description = "Load Session.vim";
      global = "startify_session_autoload";
      type = types.bool;
    };

    sessionBeforeSave = mkDefaultOpt {
      description = "Commands to be executed before saving a session";
      global = "startify_session_before_save";
      type = types.listOf types.str;
    };

    sessionPersistence = mkDefaultOpt {
      description = "Automatically update sessions";
      global = "startify_session_persistence";
      type = types.bool;
    };

    sessionDeleteBuffers = mkDefaultOpt {
      description = "Delete all buffers when loading or closing a session";
      global = "startify_session_delete_buffers";
      type = types.bool;
    };

    changeToDir = mkDefaultOpt {
      description = "When opening a file or bookmark, change to its directory";
      global = "startify_change_to_dir";
      type = types.bool;
    };

    changeToVcsRoot = mkDefaultOpt {
      description = "When opening a file or bookmark, change to the root directory of the VCS";
      global = "startify_change_to_vcs_root";
      type = types.bool;
    };

    changeCmd = mkDefaultOpt {
      description = "The default command for switching directories";
      global = "startify_change_cmd";
      type = types.enum [ "cd" "lcd" "tcd" ];
    };

    skipList = mkDefaultOpt {
      description = "A list of regexes that is used to filter recently used files";
      global = "startify_skiplist";
      type = types.listOf types.str;
    };

    useUnicode = mkDefaultOpt {
      description = "Use unicode box drawing characters for the fortune header";
      global = "startify_fortune_use_unicode";
      type = types.bool;
    };

    paddingLeft = mkDefaultOpt {
      description = "Number of spaces used for left padding";
      global = "startify_padding_left";
      type = types.int;
    };

    skipListServer = mkDefaultOpt {
      description = "Do not create the startify buffer if this is a Vim server instance with a name contained in this list";
      global = "startify_skiplist_server";
      type = types.listOf types.str;
    };

    enableSpecial = mkDefaultOpt {
      description = "Show &lt;empty buffer&gt; and &lt;quit&gt;";
      global = "startify_enable_special";
      type = types.bool;
    };

    enableUnsafe = mkDefaultOpt {
      description = "Improves start time but reduces accuracy of the file list";
      global = "startify_enable_unsafe";
      type = types.bool;
    };

    sessionRemoveLines = mkDefaultOpt {
      description = "Lines matching any of the patterns in this list will be removed from the session file";
      global = "startify_session_remove_lines";
      type = types.listOf types.str;
    };

    sessionSaveVars = mkDefaultOpt {
      description = "List of variables for Startify to save into the session file";
      global = "startify_session_savevars";
      type = types.listOf types.str;
    };

    sessionSaveCmds = mkDefaultOpt {
      description = "List of cmdline commands to run when loading the session";
      global = "startify_session_savecmds";
      type = types.listOf types.str;
    };

    sessionNumber = mkDefaultOpt {
      description = "Maximum number of sessions to display";
      global = "startify_session_number";
      type = types.listOf types.str;
    };

    sessionSort = mkDefaultOpt {
      description = "Sort sessions by modification time rather than alphabetically";
      global = "startify_session_sort";
      type = types.bool;
    };

    customIndices = mkDefaultOpt {
      description = "Use this list as indices instead of increasing numbers";
      global = "startify_custom_indices";
      type = types.listOf types.str;
    };

    customHeader = mkDefaultOpt {
      description = "Define your own header";
      global = "startify_custom_header";
      type = types.oneOf [ types.str (types.listOf types.str) ];
    };

    customQuotes = mkDefaultOpt {
      description = "Own quotes for the cowsay header";
      global = "startify_custom_header_quotes";
      # TODO this should also support funcrefs!
      type = types.listOf (types.listOf types.str);
    };

    customFooter = mkDefaultOpt {
      description = "Custom footer";
      global = "startify_custom_footer";
      type = types.str;
    };

    disableAtVimEnter = mkDefaultOpt {
      description = "Don't run Startify at Vim startup";
      global = "startify_disable_at_vimenter";
      type = types.bool;
    };

    relativePath = mkDefaultOpt {
      description = "If the file is in or below the current working directory, use a relative path";
      global = "startify_relative_path";
      type = types.bool;
    };

    useEnv = mkDefaultOpt {
      description = "Show environment variables in path, if their name is shorter than their value";
      global = "startify_use_env";
      type = types.bool;
    };
  };
}
