{
  pkgs,
  lib,
  ...
} @ args:
with lib;
with import ../helpers.nix {inherit lib;};
  {
    imports = let
      optionWarnings = import ../../lib/option-warnings.nix args;
      basePluginPath = ["plugins" "floaterm"];
    in [
      (optionWarnings.mkRenamedOption {
        option = basePluginPath ++ ["winType"];
        newOption = basePluginPath ++ ["wintype"];
      })
      (optionWarnings.mkRenamedOption {
        option = basePluginPath ++ ["winWidth"];
        newOption = basePluginPath ++ ["width"];
      })
      (optionWarnings.mkRenamedOption {
        option = basePluginPath ++ ["winHeight"];
        newOption = basePluginPath ++ ["height"];
      })
      (optionWarnings.mkRenamedOption {
        option = basePluginPath ++ ["borderChars"];
        newOption = basePluginPath ++ ["borderchars"];
      })
    ];
  }
  // mkPlugin args {
    name = "floaterm";
    description = "floaterm";
    package = pkgs.vimPlugins.vim-floaterm;

    options =
      mapAttrs (name: value:
        mkDefaultOpt {
          global = "floaterm_${name}";
          inherit (value) type description;
        })
      {
        shell = {
          type = types.str;
          description = "";
        };

        title = {
          type = types.str;
          description = ''
            Show floaterm info (e.g., 'floaterm: 1/3' implies there are 3 floaterms in total and the
            current is the first one) at the top left corner of floaterm window.

            Default: 'floaterm: $1/$2'($1 and $2 will be substituted by 'the index of the current
            floaterm' and 'the count of all floaterms' respectively)

            Example: 'floaterm($1|$2)'
          '';
        };

        wintype = {
          type = types.enum ["float" "split" "vsplit"];
          description = ''
            'float'(nvim's floating or vim's popup) by default.
            Set it to 'split' or 'vsplit' if you don't want to use floating or popup window.
          '';
        };

        width = {
          type = types.either types.int types.float;
          description = ''
            Int (number of columns) or float (between 0 and 1).
            if float, the width is relative to &columns.

            Default: 0.6
          '';
        };

        height = {
          type = types.either types.int types.float;
          description = ''
            Int (number of columns) or float (between 0 and 1).
            if float, the height is relative to &lines.

            Default: 0.6
          '';
        };

        position = {
          type = types.str;
          description = ''
            The position of the floating window.

            Available values:
            - If wintype is `split`/`vsplit`: 'leftabove', 'aboveleft', 'rightbelow', 'belowright', 'topleft', 'botright'.
              Default: 'botright'.

            - If wintype is float: 'top', 'bottom', 'left', 'right', 'topleft', 'topright', 'bottomleft', 'bottomright', 'center', 'auto' (at the cursor place).
            Default: 'center'

            In addition, there is another option 'random' which allows to pick a random position from
            above when (re)opening a floaterm window.
          '';
        };

        borderchars = {
          type = types.str;
          description = ''
            The position of the floating window.

            8 characters of the floating window border (top, right, bottom, left, topleft, topright, botright, botleft).

            Default: "─│─│┌┐┘└"
          '';
        };

        rootmarkers = {
          type = types.listOf types.str;
          description = ''

            Markers used to detect the project root directory for --cwd=<root>

            Default: [".project" ".git" ".hg" ".svn" ".root"]
          '';
        };

        giteditor = {
          type = types.bool;
          description = ''
            Whether to override $GIT_EDITOR in floaterm terminals so git commands can open open an
            editor in the same neovim instance.

            Default: true
          '';
        };

        opener = {
          type = types.enum ["edit" "split" "vsplit" "tabe" "drop"];
          description = ''
            Command used for opening a file in the outside nvim from within `:terminal`.

            Default: 'split'
          '';
        };

        autoclose = {
          type = types.enum [0 1 2];
          description = ''
            Whether to close floaterm window once the job gets finished.

            - 0: Always do NOT close floaterm window
            - 1: Close window if the job exits normally, otherwise stay it with messages like [Process exited 101]
            - 2: Always close floaterm window

            Default: 1
          '';
        };

        autohide = {
          type = types.enum [0 1 2];
          description = ''
            Whether to hide previous floaterms before switching to or opening a another one.

            - 0: Always do NOT hide previous floaterm windows
            - 1: Only hide those whose position (b:floaterm_position) is identical to that of the floaterm which will be opened
            - 2: Always hide them

            Default: 1
          '';
        };

        autoinsert = {
          type = types.bool;
          description = ''
            Whether to enter Terminal-mode after opening a floaterm.

            Default: true
          '';
        };
      };
  }
