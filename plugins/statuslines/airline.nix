{
  lib,
  pkgs,
  ...
} @ args:
with lib;
with (import ../helpers.nix {inherit lib;}).vim-plugin;
  mkVimPlugin args {
    name = "airline";
    description = "vim-airline";
    package = pkgs.vimPlugins.vim-airline;
    globalPrefix = "airline_";

    options =
      (
        listToAttrs (
          map
          (
            name:
              nameValuePair
              "section${toUpper name}"
              (mkDefaultOpt {
                global = "section_${name}";
                type = with types;
                  oneOf
                  [
                    str
                    (listOf str)
                    (attrsOf anything)
                  ];
                description = "Configuration for this section.";
              })
          )
          ["a" "b" "c" "x" "y" "z"]
        )
      )
      // {
        experimental = mkDefaultOpt {
          description = ''
            Enable experimental features.
            Currently: Enable Vim9 Script implementation.

            Default: `true`
          '';
          type = types.bool;
        };

        leftSep = mkDefaultOpt {
          global = "left_sep";
          description = ''
            The separator used on the left side.

            Default: ">"
          '';
          type = types.str;
        };

        rightSep = mkDefaultOpt {
          global = "right_sep";
          description = ''
            The separator used on the right side.

            Default: "<"
          '';
          type = types.str;
        };

        detectModified = mkDefaultOpt {
          global = "detect_modified";
          description = ''
            Enable modified detection.

            Default: `true`
          '';
          type = types.bool;
        };

        detectPaste = mkDefaultOpt {
          global = "detect_paste";
          description = ''
            Enable paste detection.

            Default: `true`
          '';
          type = types.bool;
        };

        detectCrypt = mkDefaultOpt {
          global = "detect_crypt";
          description = ''
            Enable crypt detection.

            Default: `true`
          '';
          type = types.bool;
        };

        detectSpell = mkDefaultOpt {
          global = "detect_spell";
          description = ''
            Enable spell detection.

            Default: `true`
          '';
          type = types.bool;
        };

        detectSpelllang = mkDefaultOpt {
          global = "detect_spelllang";
          description = ''
            Display spelling language when spell detection is enabled (if enough space is available).

            Set to 'flag' to get a unicode icon of the relevant country flag instead of the
            'spelllang' itself.

            Default: `true`
          '';
          type = with types; either bool (enum ["flag"]);
        };

        detectIminsert = mkDefaultOpt {
          global = "detect_iminsert";
          description = ''
            Enable iminsert detection.

            Default: `false`
          '';
          type = types.bool;
        };

        inactiveCollapse = mkDefaultOpt {
          global = "inactive_collapse";
          description = ''
            Determine whether inactive windows should have the left section collapsed to only the
            filename of that buffer.

            Default: `true`
          '';
          type = types.bool;
        };

        inactiveAltSep = mkDefaultOpt {
          global = "inactive_alt_sep";
          description = ''
            Use alternative separators for the statusline of inactive windows.

            Default: `true`
          '';
          type = types.bool;
        };

        theme = mkDefaultOpt {
          description = ''
            Themes are automatically selected based on the matching colorscheme.
            This can be overridden by defining a value.

            Note: Only the dark theme is distributed with vim-airline.
            For more themes, checkout the vim-airline-themes repository
            (https://github.com/vim-airline/vim-airline-themes)

            Default: "dark"
          '';
          type = types.str;
        };

        themePatchFunc = mkDefaultOpt {
          global = "theme_patch_func";
          description = ''
            If you want to patch the airline theme before it gets applied, you can supply the name of
            a function where you can modify the palette.

            Example: "AirlineThemePatch"

            Then, define this function using `extraConfigVim`:
            ```nix
              extraConfigVim = \'\'
                function! AirlineThemePatch(palette)
                  if g:airline_theme == 'badwolf'
                    for colors in values(a:palette.inactive)
                      let colors[3] = 245
                    endfor
                  endif
                endfunction
              \'\';
            ```
          '';
          type = types.str;
        };

        powerlineFonts = mkDefaultOpt {
          global = "powerline_fonts";
          description = ''
            By default, airline will use unicode symbols if your encoding matches utf-8.
            If you want the powerline symbols set this variable to `true`.

            Default: `false`
          '';
          type = types.bool;
        };

        symbolsAscii = mkDefaultOpt {
          global = "symbols_ascii";
          description = ''
            By default, airline will use unicode symbols if your encoding matches utf-8.
            If you want to use plain ascii symbols, set this variable: >

            Default: `false`
          '';
          type = types.bool;
        };

        modeMap = mkDefaultOpt {
          global = "mode_map";
          description = ''
            Define the set of text to display for each mode.

            Default: see source
          '';
          type = with types; attrsOf str;
        };

        excludeFilenames = mkDefaultOpt {
          global = "exclude_filenames";
          description = ''
            Define the set of filename match queries which excludes a window from having its
            statusline modified.

            Default: see source for current list
          '';
          type = with types; listOf str;
        };

        excludeFiletypes = mkDefaultOpt {
          global = "exclude_filetypes";
          description = ''
            Define the set of filetypes which are excluded from having its window statusline modified.

            Default: see source for current list
          '';
          type = with types; listOf str;
        };

        filetypeOverrides = mkDefaultOpt {
          global = "filetype_overrides";
          description = ''
            Define the set of names to be displayed instead of a specific filetypes.

            Example:
            ```nix
              {
                coc-explorer =  ["CoC Explorer" ""];
                defx = ["defx" "%{b:defx.paths[0]}"];
                fugitive = ["fugitive" "%{airline#util#wrap(airline#extensions#branch#get_head(),80)}"];
                gundo = ["Gundo" "" ];
                help = ["Help" "%f"];
                minibufexpl = ["MiniBufExplorer" ""];
                startify = ["startify" ""];
                vim-plug = ["Plugins" ""];
                vimfiler = ["vimfiler" "%{vimfiler#get_status_string()}"];
                vimshell = ["vimshell" "%{vimshell#get_status_string()}"];
                vaffle = ["Vaffle" "%{b:vaffle.dir}"];
              }
            ```
          '';
          type = with types; attrsOf (listOf str);
        };

        excludePreview = mkDefaultOpt {
          global = "exclude_filenames";
          description = ''
            Defines whether the preview window should be excluded from having its window statusline
            modified (may help with plugins which use the preview window heavily).

            Default: `false`
          '';
          type = types.bool;
        };

        disableStatusline = mkDefaultOpt {
          global = "disable_statusline";
          description = ''
            Disable the Airline statusline customization globally.

            This setting disables setting the 'statusline' option.
            This allows to use e.g. the tabline extension (`|airline-tabline|`) but keep the
            'statusline' option totally configurable by a custom configuration.

            Default: `false`
          '';
          type = types.bool;
        };

        skipEmptySections = mkDefaultOpt {
          global = "skip_empty_sections";
          description = ''
            Do not draw separators for empty sections (only for the active window).

            Default: `true`
          '';
          type = types.bool;
        };

        highlightingCache = mkDefaultOpt {
          global = "highlighting_cache";
          description = ''
            Caches the changes to the highlighting groups, should therefore be faster.
            Set this to one, if you experience a sluggish Vim.

            Default: `false`
          '';
          type = types.bool;
        };

        focuslostInactive = mkDefaultOpt {
          global = "focuslost_inactive";
          description = ''
            Disable airline on FocusLost autocommand (e.g. when Vim loses focus).

            Default: `false`
          '';
          type = types.bool;
        };

        statuslineOntop = mkDefaultOpt {
          global = "statusline_ontop";
          description = ''
            Display the statusline in the tabline (first top line).

            Setting this option, allows to use the statusline option to be used by a custom function
            or another plugin, since airline won't change it.

            Note: This setting is experimental and works on a best effort approach.
            Updating the statusline might not always happen as fast as needed, but that is a
            limitation, that comes from Vim.
            airline tries to force an update if needed, but it might not always work as expected.
            To force updating the tabline on mode changes, call `airline#check_mode()` in your custom
            statusline setting: `:set stl=%!airline#check_mode(winnr())` will correctly update the
            tabline on mode changes.

            Default: `false`
          '';
          type = types.bool;
        };

        stlPathStyle = mkDefaultOpt {
          global = "stl_path_style";
          description = ''
            Display a short path in statusline.

            Default: "short"
          '';
          type = types.str;
        };

        sectionCOnlyFilename = mkDefaultOpt {
          global = "section_c_only_filename";
          description = ''
            Display a only file name in statusline.

            Default: `true`
          '';
          type = types.bool;
        };

        symbols = mkDefaultOpt {
          description = ''
            Customize airline symbols.

            Example:
            ```nix
              {
                branch = "";
                colnr = " ℅:";
                readonly = "";
                linenr = " :";
                maxlinenr = "☰ ";
                dirty= "⚡";
              }
            ```
          '';
          type = with types; attrsOf str;
        };
      };
  }
