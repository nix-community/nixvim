{
  lib,
  options,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lightline";
  package = "lightline-vim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    A light and configurable statusline/tabline plugin for Vim.

    ---

    ### Example of defining your own component_function

    ```nix
    plugins.lightline = {
       enable = true;
       settings.component_function = {
         readonly = "LightlineReadonly";
       };

       luaConfig.pre = '''
         function LightlineReadonly()
           local is_readonly = vim.bo.readonly == 1
           local filetype = vim.bo.filetype

           if is_readonly and filetype ~= "help" then
             return "RO"
           else
             return ""
           end
         end
       ''';
     };
    ```
  '';

  settingsOptions = {
    colorscheme = defaultNullOpts.mkStr "default" ''
      The colorscheme to use for lightline.
      Default theme is equal to `powerline`.

      List of supported colorschemes can be found at
      https://github.com/itchyny/lightline.vim/blob/master/colorscheme.md.
    '';

    component_function = defaultNullOpts.mkAttrsOf types.str { } ''
      A list of function component definitions.

      You can use the name of a function defined elsewhere.
    '';

    component =
      defaultNullOpts.mkAttrsOf types.str
        {
          mode = "%{lightline#mode()}";
          absolutepath = "%F";
          relativepath = "%f";
          filename = "%t";
          modified = "%M";
          bufnum = "%n";
          paste = ''%{&paste?"PASTE"=""}'';
          readonly = "%R";
          charvalue = "%b";
          charvaluehex = "%B";
          fileencoding = ''%{&fenc!=#" "?&fenc=&enc}'';
          fileformat = "%{&ff}";
          filetype = ''%{&ft!=#""?&ft="no ft"}'';
          percent = "%3p%%";
          percentwin = "%P";
          spell = ''%{&spell?&spelllang=" "}'';
          lineinfo = "%3l=%-2c";
          line = "%l";
          column = "%c";
          close = "%999X X ";
          winnr = "%{winnr()}";
        }
        ''
          Lightline component definitions. Uses 'statusline' syntax.

          Consult `:h 'statusline'` for a list of what's available.
        '';

    active =
      defaultNullOpts.mkAttrsOf (with types; listOf (listOf str))
        {
          left = [
            [
              "mode"
              "paste"
            ]
            [
              "readonly"
              "filename"
              "modified"
            ]
          ];
          right = [
            [ "lineinfo" ]
            [ "percent" ]
            [
              "fileformat"
              "fileencoding"
              "filetype"
            ]
          ];
        }
        ''
          Components placement for the active window.
        '';

    inactive =
      defaultNullOpts.mkAttrsOf (with types; listOf (listOf str))
        {
          left = [ "filename" ];
          right = [
            [ "lineinfo" ]
            [ "percent" ]
          ];
        }
        ''
          Components placement for inactive windows.
        '';

    tabline =
      defaultNullOpts.mkAttrsOf (with types; listOf (listOf str))
        {
          left = [ [ "tabs" ] ];
          right = [ [ "close" ] ];
        }
        ''
          Components placement for tabline.
        '';

    tab = defaultNullOpts.mkAttrsOf (with types; listOf str) {
      active = [
        "tabnum"
        "filename"
        "modified"
      ];
      inactive = [
        "tabnum"
        "filename"
        "modified"
      ];
    } "A dictionary to store the tab components in each tabs.";

    mode_map =
      defaultNullOpts.mkAttrsOf types.str
        {
          "n" = "NORMAL";
          "i" = "INSERT";
          "R" = "REPLACE";
          "v" = "VISUAL";
          "V" = "V-LINE";
          "\<C-v>" = "V-BLOCK";
          "c" = "COMMAND";
          "s" = "SELECT";
          "S" = "S-LINE";
          "\<C-s>" = "S-BLOCK";
          "t" = "TERMINAL";
        }
        ''
          Mode name mappings
        '';
  };

  settingsExample = {
    colorscheme = "one";
    component_function = {
      gitbranch = "FugitiveHead";
    };
    component = {
      charvaluehex = "0x%B";
      lineinfo = "%3l:%-2v%<";
    };
    active = {
      right = [
        [ "lineinfo" ]
        [ "percent" ]
        [
          "fileformat"
          "fileencoding"
          "filetype"
          "charvaluehex"
        ]
      ];
    };
    inactive = [ ];
    mode_map = {
      "n" = "N";
      "i" = "I";
      "v" = "V";
      "<C-v>" = "VB";
      "<C-s>" = "SB";
    };
  };

  callSetup = false;
  extraConfig = {
    globals.lightline = lib.modules.mkAliasAndWrapDefsWithPriority lib.id options.plugins.lightline.settings;
  };
}
