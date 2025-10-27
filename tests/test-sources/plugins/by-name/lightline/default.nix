{
  empty = {
    plugins.lightline.enable = true;
  };

  defaults = {
    plugins.lightline = {
      enable = true;

      settings = {
        colorscheme = "default";
        component_function.__raw = "nil";
        component = {
          mode = ''%{lightline#mode()}'';
          absolutepath = "%F";
          relativepath = "%f";
          filename = "%t";
          modified = "%M";
          bufnum = "%n";
          paste = ''%{&paste?"PASTE":""}'';
          readonly = "%R";
          charvalue = "%b";
          charvaluehex = "%B";
          fileencoding = ''%{&fenc!=#""?&fenc:&enc}'';
          fileformat = ''%{&ff}'';
          filetype = ''%{&ft!=#""?&ft:"no ft"}'';
          percent = "%3p%%";
          percentwin = "%P";
          spell = ''%{&spell?&spelllang:""}'';
          lineinfo = ''%3l=%-2c'';
          line = "%l";
          column = "%c";
          close = "%999X X ";
          winnr = ''%{winnr()}'';
        };
        active = {
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
        };
        inactive = {
          left = [ [ "filename" ] ];
          right = [
            [ "lineinfo" ]
            [ "percent" ]
          ];
        };
        tabline = {
          left = [ [ "tabs" ] ];
          right = [ [ "close" ] ];
        };
        tab = {
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
        };
        mode_map = {
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
        };
      };
    };
  };

  example = {
    extraConfigLua = ''
      function LightlineReadonly()
        local is_readonly = vim.bo.readonly == 1
        local filetype = vim.bo.filetype

        if is_readonly and filetype ~= "help" then
          return "RO"
        else
          return ""
        end
      end
    '';

    plugins.lightline = {
      enable = true;

      settings = {
        colorscheme = "one";
        component_function = {
          gitbranch = "FugitiveHead";
          readonly = "LightlineReadOnly";
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
        inactive.__raw = "nil";
        mode_map = {
          "n" = "N";
          "i" = "I";
          "v" = "V";
          "<C-v>" = "VB";
          "<C-s>" = "SB";
        };
      };
    };
  };
}
