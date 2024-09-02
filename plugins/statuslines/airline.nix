{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
mkVimPlugin {
  name = "airline";
  originalName = "vim-airline";
  defaultPackage = pkgs.vimPlugins.vim-airline;
  globalPrefix = "airline_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "sectionA"
    "sectionB"
    "sectionC"
    "sectionX"
    "sectionY"
    "sectionZ"
    "experimental"
    "leftSep"
    "rightSep"
    "detectModified"
    "detectPaste"
    "detectCrypt"
    "detectSpell"
    "detectSpelllang"
    "detectIminsert"
    "inactiveCollapse"
    "inactiveAltSep"
    "theme"
    "themePatchFunc"
    "powerlineFonts"
    "symbolsAscii"
    "modeMap"
    "excludeFilenames"
    "excludeFiletypes"
    "filetypeOverrides"
    "excludePreview"
    "disableStatusline"
    "skipEmptySections"
    "highlightingCache"
    "focuslostInactive"
    "statuslineOntop"
    "stlPathStyle"
    "sectionCOnlyFilename"
    "symbols"
  ];

  settingsOptions =
    (listToAttrs (
      map
        (
          name:
          nameValuePair "section_${name}" (
            helpers.mkNullOrOption (
              with helpers.nixvimTypes;
              oneOf [
                rawLua
                str
                (listOf str)
                (attrsOf anything)
              ]
            ) "Configuration for this section."
          )
        )
        [
          "a"
          "b"
          "c"
          "x"
          "y"
          "z"
        ]
    ))
    // {
      experimental = helpers.defaultNullOpts.mkBool true ''
        Enable experimental features.
        Currently: Enable Vim9 Script implementation.
      '';

      left_sep = helpers.defaultNullOpts.mkStr ">" ''
        The separator used on the left side.
      '';

      right_sep = helpers.defaultNullOpts.mkStr "<" ''
        The separator used on the right side.
      '';

      detect_modified = helpers.defaultNullOpts.mkBool true ''
        Enable modified detection.
      '';

      detect_paste = helpers.defaultNullOpts.mkBool true ''
        Enable paste detection.
      '';

      detect_crypt = helpers.defaultNullOpts.mkBool true ''
        Enable crypt detection.
      '';

      detect_spell = helpers.defaultNullOpts.mkBool true ''
        Enable spell detection.
      '';

      detect_spelllang =
        helpers.defaultNullOpts.mkNullable
          (
            with helpers.nixvimTypes;
            oneOf [
              rawLua
              bool
              (enum [ "flag" ])
            ]
          )
          true
          ''
            Display spelling language when spell detection is enabled (if enough space is
            available).

            Set to 'flag' to get a unicode icon of the relevant country flag instead of the
            'spelllang' itself.
          '';

      detect_iminsert = helpers.defaultNullOpts.mkBool false ''
        Enable iminsert detection.
      '';

      inactive_collapse = helpers.defaultNullOpts.mkBool true ''
        Determine whether inactive windows should have the left section collapsed to only the
        filename of that buffer.
      '';

      inactive_alt_sep = helpers.defaultNullOpts.mkBool true ''
        Use alternative separators for the statusline of inactive windows.
      '';

      theme = helpers.defaultNullOpts.mkStr "dark" ''
        Themes are automatically selected based on the matching colorscheme.
        This can be overridden by defining a value.

        Note: Only the dark theme is distributed with vim-airline.
        For more themes, checkout the vim-airline-themes repository
        (https://github.com/vim-airline/vim-airline-themes)
      '';

      theme_patch_func = helpers.mkNullOrStr ''
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

      powerline_fonts = helpers.defaultNullOpts.mkBool false ''
        By default, airline will use unicode symbols if your encoding matches utf-8.
        If you want the powerline symbols set this variable to `true`.
      '';

      symbols_ascii = helpers.defaultNullOpts.mkBool false ''
        By default, airline will use unicode symbols if your encoding matches utf-8.
        If you want to use plain ascii symbols, set this variable: >
      '';

      mode_map = helpers.mkNullOrOption (with helpers.nixvimTypes; maybeRaw (attrsOf str)) ''
        Define the set of text to display for each mode.

        Default: see source
      '';

      exclude_filenames = helpers.mkNullOrOption (with helpers.nixvimTypes; maybeRaw (listOf str)) ''
        Define the set of filename match queries which excludes a window from having its
        statusline modified.

        Default: see source for current list
      '';

      exclude_filetypes = helpers.mkNullOrOption (with helpers.nixvimTypes; maybeRaw (listOf str)) ''
        Define the set of filetypes which are excluded from having its window statusline modified.

        Default: see source for current list
      '';

      filetype_overrides =
        helpers.mkNullOrOption (with helpers.nixvimTypes; maybeRaw (attrsOf (listOf str)))
          ''
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

      exclude_preview = helpers.defaultNullOpts.mkBool false ''
        Defines whether the preview window should be excluded from having its window statusline
        modified (may help with plugins which use the preview window heavily).
      '';

      disable_statusline = helpers.defaultNullOpts.mkBool false ''
        Disable the Airline statusline customization globally.

        This setting disables setting the 'statusline' option.
        This allows to use e.g. the tabline extension (`|airline-tabline|`) but keep the
        'statusline' option totally configurable by a custom configuration.
      '';

      skip_empty_sections = helpers.defaultNullOpts.mkBool true ''
        Do not draw separators for empty sections (only for the active window).
      '';

      highlighting_cache = helpers.defaultNullOpts.mkBool false ''
        Caches the changes to the highlighting groups, should therefore be faster.
        Set this to one, if you experience a sluggish Vim.
      '';

      focuslost_inactive = helpers.defaultNullOpts.mkBool false ''
        Disable airline on FocusLost autocommand (e.g. when Vim loses focus).
      '';

      statusline_ontop = helpers.defaultNullOpts.mkBool false ''
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
      '';

      stl_path_style = helpers.defaultNullOpts.mkStr "short" ''
        Display a short path in statusline.
      '';

      section_c_only_filename = helpers.defaultNullOpts.mkBool true ''
        Display a only file name in statusline.
      '';

      symbols = helpers.mkNullOrOption (with types; attrsOf str) ''
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
    };

  settingsExample = {
    powerline_fonts = true;
    theme = "base16";
    skip_empty_sections = true;
  };
}
