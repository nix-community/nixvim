{
  empty = {
    plugins.hardtime.enable = true;
  };

  defaults = {
    plugins.hardtime = {
      enable = true;

      settings = {
        max_time = 1000;
        max_count = 2;
        disable_mouse = true;
        hint = true;
        notification = true;
        allow_different_key = false;
        enabled = true;
        restriction_mode = "block";

        resetting_keys = {
          "1" = [
            "n"
            "x"
          ];
          "2" = [
            "n"
            "x"
          ];
          "3" = [
            "n"
            "x"
          ];
          "4" = [
            "n"
            "x"
          ];
          "5" = [
            "n"
            "x"
          ];
          "6" = [
            "n"
            "x"
          ];
          "7" = [
            "n"
            "x"
          ];
          "8" = [
            "n"
            "x"
          ];
          "9" = [
            "n"
            "x"
          ];
          "c" = [ "n" ];
          "C" = [ "n" ];
          "d" = [ "n" ];
          "x" = [ "n" ];
          "X" = [ "n" ];
          "y" = [ "n" ];
          "Y" = [ "n" ];
          "p" = [ "n" ];
          "P" = [ "n" ];
        };

        restricted_keys = {
          "h" = [
            "n"
            "x"
          ];
          "j" = [
            "n"
            "x"
          ];
          "k" = [
            "n"
            "x"
          ];
          "l" = [
            "n"
            "x"
          ];
          "-" = [
            "n"
            "x"
          ];
          "+" = [
            "n"
            "x"
          ];
          "gj" = [
            "n"
            "x"
          ];
          "gk" = [
            "n"
            "x"
          ];
          "<CR>" = [
            "n"
            "x"
          ];
          "<C-M>" = [
            "n"
            "x"
          ];
          "<C-N>" = [
            "n"
            "x"
          ];
          "<C-P>" = [
            "n"
            "x"
          ];
        };

        disabled_keys = {
          "<Up>" = [
            ""
            "i"
          ];
          "<Down>" = [
            ""
            "i"
          ];
          "<Left>" = [
            ""
            "i"
          ];
          "<Right>" = [
            ""
            "i"
          ];
        };

        disabled_file_types = [
          "qf"
          "netrw"
          "NvimTree"
          "lazy"
          "mason"
        ];

        hints = {
          "[kj]%^" = {
            message.__raw = ''
              function(key)
               return "Use "
                .. (key == "k^" and "-" or "<CR> or +")
                .. " instead of "
                .. key
              end
            '';
            length = 2;
          };

          "%$a" = {
            message.__raw = ''
              function()
               return "Use A instead of $a"
              end
            '';
            length = 2;
          };

          "%^i" = {
            message.__raw = ''
              function()
                return "Use I instead of ^i"
              end
            '';
            length = 2;
          };

          "%D[k-]o" = {
            message.__raw = ''
              function(keys)
                return "Use O instead of " .. keys:sub(2)
              end
            '';
            length = 3;
          };

          "%D[j+]O" = {
            message.__raw = ''
              function(keys)
                return "Use o instead of " .. keys:sub(2)
              end
            '';
            length = 3;
          };

          "[^fFtT]li" = {
            message.__raw = ''
              function()
                return "Use a instead of li"
              end
            '';
            length = 3;
          };

          "2([dcy=<>])%1" = {
            message.__raw = ''
              function(key)
                return "Use " .. key:sub(3) .. "j instead of " .. key
              end
            '';
            length = 3;
          };

          "[^dcy=]f.h" = {
            message.__raw = ''
              function(keys)
                return "Use t" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
              end
            '';
            length = 4;
          };

          "[^dcy=]F.l" = {
            message.__raw = ''
              function(keys)
                return "Use T" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
              end
            '';
            length = 4;
          };

          "[^dcy=]T.h" = {
            message.__raw = ''
              function(keys)
                return "Use F" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
              end
            '';
            length = 4;
          };

          "[^dcy=]t.l" = {
            message.__raw = ''
              function(keys)
                return "Use f" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
              end
            '';
            length = 4;
          };

          "d[bBwWeE%^%$]i" = {
            message.__raw = ''
              function(keys)
                return "Use " .. "c" .. keys:sub(2, 2) .. " instead of " .. keys
              end
            '';
            length = 3;
          };

          "dg[eE]i" = {
            message.__raw = ''
              function(keys)
                return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
              end
            '';
            length = 4;
          };

          "d[tTfF].i" = {
            message.__raw = ''
              function(keys)
                return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
              end
            '';
            length = 4;
          };

          "d[ia][\"'`{}%[%]()<>bBwWspt]i" = {
            message.__raw = ''
              function(keys)
                return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
              end
            '';
            length = 4;
          };

          "Vgg[dcy=<>]" = {
            message.__raw = ''
              function(keys)
                return "Use " .. keys:sub(4, 4) .. "gg instead of " .. keys
              end
            '';
            length = 4;
          };

          "Vgg\".[dy]" = {
            message.__raw = ''
              function(keys)
                return "Use " .. keys:sub(4, 6) .. "gg instead of " .. keys
              end
            '';
            length = 6;
          };

          "VG[dcy=<>]" = {
            message.__raw = ''
              function(keys)
                return "Use " .. keys:sub(3, 3) .. "G instead of " .. keys
              end
            '';
            length = 3;
          };

          "VG\".[dy]" = {
            message.__raw = ''
              function(keys)
                return "Use " .. keys:sub(3, 5) .. "G instead of " .. keys
              end
            '';
            length = 5;
          };

          "V%d[kj][dcy=<>]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(4, 4)
                  .. keys:sub(2, 3)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 4;
          };

          "V%d[kj]\".[dy]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(4, 6)
                  .. keys:sub(2, 3)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 6;
          };

          "V%d%d[kj][dcy=<>]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(5, 5)
                  .. keys:sub(2, 4)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 5;
          };

          "V%d%d[kj]\".[dy]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(5, 7)
                  .. keys:sub(2, 4)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 7;
          };

          "[vV][bBwWeE%^%$][dcy=<>]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(3, 3)
                  .. keys:sub(2, 2)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 3;
          };

          "[vV][bBwWeE%^%$]\".[dy]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(3, 5)
                  .. keys:sub(2, 2)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 5;
          };

          "[vV]g[eE][dcy=<>]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(4, 4)
                  .. keys:sub(2, 3)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 4;
          };

          "[vV]g[eE]\".[dy]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(4, 6)
                  .. keys:sub(2, 3)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 6;
          };

          "[vV][tTfF].[dcy=<>]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(4, 4)
                  .. keys:sub(2, 3)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 4;
          };

          "[vV][tTfF].\".[dy]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(4, 6)
                  .. keys:sub(2, 3)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 6;
          };
          "[vV][ia][\"'`{}%[%]()<>bBwWspt][dcy=<>]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(4, 4)
                  .. keys:sub(2, 3)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 4;
          };

          "[vV][ia][\"'`{}%[%]()<>bBwWspt]\".[dy]" = {
            message.__raw = ''
              function(keys)
                return "Use "
                  .. keys:sub(4, 6)
                  .. keys:sub(2, 3)
                  .. " instead of "
                  .. keys
              end
            '';
            length = 6;
          };
        };
      };
    };
  };

  example = {
    plugins.hardtime = {
      enable = true;

      settings = {
        showmode = false;
      };
    };
  };
}
