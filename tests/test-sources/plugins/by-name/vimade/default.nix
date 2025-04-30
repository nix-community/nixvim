{
  empty = {
    plugins.vimade.enable = true;
  };

  example = {
    plugins.vimade = {
      enable = true;

      settings = {
        fadelevel = 0.7;
        recipe = [
          "duo"
          { animate = true; }
        ];
        tint = {
          bg = {
            rgb = [
              255
              255
              255
            ];
            intensity = 0.1;
          };
          fg = {
            rgb = [
              255
              255
              255
            ];
            intensity = 0.1;
          };
        };
      };
    };
  };

  defaults = {
    plugins.vimade = {
      enable = true;

      settings = {
        recipe = [
          "default"
          { animate = false; }
        ];
        ncmode = "buffers";
        fadelevel = 0.4;
        basebg = "";
        tint = {
        };
        blocklist = {
          default = {
            highlights = {
              laststatus_3.__raw = ''
                function(win, active)
                  -- Global statusline, laststatus=3, is currently disabled as multiple windows take
                  -- ownership of the StatusLine highlight (see #85).
                  if vim.go.laststatus == 3 then
                      -- you can also return tables (e.g. {'StatusLine', 'StatusLineNC'})
                      return 'StatusLine'
                  end
                end
              '';
              __unkeyed-1 = "TabLineSel";
              __unkeyed-2 = "Pmenu";
              __unkeyed-3 = "PmenuSel";
              __unkeyed-4 = "PmenuKind";
              __unkeyed-5 = "PmenuKindSel";
              __unkeyed-6 = "PmenuExtra";
              __unkeyed-7 = "PmenuExtraSel";
              __unkeyed-8 = "PmenuThumb";
            };
            buf_opts = {
              buftype = [ "prompt" ];
            };
          };
          default_block_floats.__raw = ''
            function (win, active)
              return win.win_config.relative ~= "" and
                (win ~= active or win.buf_opts.buftype =='terminal') and true or false
            end
          '';
        };
        link = [ ];
        groupdiff = true;
        groupscrollbind = false;
        enablefocusfading = false;
        checkinterval = 1000;
        usecursorhold = false;
        nohlcheck = true;
        focus = {
          providers = {
            filetypes = {
              default = [
                [
                  "treesitter"
                  {
                    min_node_size = 2;
                    min_size = 1;
                    max_size = 0;
                    exclude = [
                      "script_file"
                      "stream"
                      "document"
                      "source_file"
                      "translation_unit"
                      "chunk"
                      "module"
                      "stylesheet"
                      "statement_block"
                      "block"
                      "pair"
                      "program"
                      "switch_case"
                      "catch_clause"
                      "finally_clause"
                      "property_signature"
                      "dictionary"
                      "assignment"
                      "expression_statement"
                      "compound_statement"
                    ];
                  }
                ]
                [
                  "blanks"
                  {
                    min_size = 1;
                    max_size = "35%";
                  }
                ]
                [
                  "static"
                  {
                    size = "35%";
                  }
                ]
              ];
            };
          };
        };
      };
    };
  };
}
