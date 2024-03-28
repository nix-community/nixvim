{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; {
  options.plugins.spectre = let
    option = defaults:
      helpers.defaultNullOpts.mkNullable
      (with types; attrsOf attrs)
      defaults
      "placeholder option";
  in
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-spectre";

      package = helpers.mkPackageOption "nvim-spectre" pkgs.vimPlugins.nvim-spectre;

      colorDevicon = helpers.defaultNullOpts.mkBool true "If set to true will color devicons";

      openCmd = helpers.defaultNullOpts.mkStr "vnew" "Command to run when opening spectre";

      liveUpdate = helpers.defaultNullOpts.mkBool false "If set to true will auto execute search again when you write to any file in vim";

      lineSepStart = helpers.defaultNullOpts.mkStr "┌-----------------------------------------" "Shown to Separate search and search results";

      resultPadding = helpers.defaultNullOpts.mkStr "¦  " "Shown for padding the result on the left";

      lineSep = helpers.defaultNullOpts.mkStr "└-----------------------------------------" "Shown at the bottom of the search results";

      highlight = {
        ui = helpers.defaultNullOpts.mkStr "String";
        search = helpers.defaultNullOpts.mkStr "DiffChange";
        replace = helpers.defaultNullOpts.mkStr "DiffDelete";
      };

      mappings =
        option
        ''
          ```lua
          {
          	['toggle_line'] = {
          			map = "dd",
          			cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          			desc = "toggle item"
          	},
          	['enter_file'] = {
          			map = "<cr>",
          			cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          			desc = "open file"
          	},
          	['send_to_qf'] = {
          			map = "<leader>q",
          			cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          			desc = "send all items to quickfix"
          	},
          	['replace_cmd'] = {
          			map = "<leader>c",
          			cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          			desc = "input replace command"
          	},
          	['show_option_menu'] = {
          			map = "<leader>o",
          			cmd = "<cmd>lua require('spectre').show_options()<CR>",
          			desc = "show options"
          	},
          	['run_current_replace'] = {
          		map = "<leader>rc",
          		cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
          		desc = "replace current line"
          	},
          	['run_replace'] = {
          			map = "<leader>R",
          			cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          			desc = "replace all"
          	},
          	['change_view_mode'] = {
          			map = "<leader>v",
          			cmd = "<cmd>lua require('spectre').change_view()<CR>",
          			desc = "change result view mode"
          	},
          	['change_replace_sed'] = {
          		map = "trs",
          		cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          		desc = "use sed to replace"
          	},
          	['change_replace_oxi'] = {
          		map = "tro",
          		cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          		desc = "use oxi to replace"
          	},
          	['toggle_live_update']={
          		map = "tu",
          		cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          		desc = "update when vim writes to file"
          	},
          	['toggle_ignore_case'] = {
          		map = "ti",
          		cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          		desc = "toggle ignore case"
          	},
          	['toggle_ignore_hidden'] = {
          		map = "th",
          		cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          		desc = "toggle search hidden"
          	},
          	['resume_last_search'] = {
          		map = "<leader>l",
          		cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
          		desc = "repeat last search"
          	}
          }
          ```
        '';
      findEngine = {
        "rg" = {
          cmd = helpers.defaultNullOpts.mkStr "rg";
          args = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[
					'--color=never'
					'--no-heading'
					'--with-filename'
					'--line-number'
					'--column'
				]" ''Default arguments passed to the rg command'';
          options =
            option
            ''
                  ```lua
                  {
              ['ignore-case'] = {
              	value= "--ignore-case",
              	icon="[I]",
              	desc="ignore case"
              },
              ['hidden'] = {
              	value="--hidden",
              	desc="hidden file",
              	icon="[H]"
              },
                  }
                  ```
            '' ''You can put any rg search option you want here it can toggle with show_option function'';
        };
        "ag" = {
          cmd = helpers.defaultNullOpts.mkStr "ag";
          args = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[
					 '--vimgrep'
					'-s'
				  ]" ''Default arguments passed to the ag command'';
          options =
            option
            ''
              ```lua
              {
                      ['ignore-case'] = {
                      	value= "-i",
                      	icon="[I]",
                      	desc="ignore case"
                      },
                      ['hidden'] = {
                      	value="--hidden",
                      	desc="hidden file",
                      	icon="[H]"
                      },
              }
              ```
            '' ''You can put any ag search option you want here it can toggle with show_option function'';
        };
      };
      replaceEngine = {
        "sed" = {
          cmd = helpers.defaultNullOpts.mkStr "sed";
          args = helpers.defaultNullOpts.mkNullable (with types; listOf str) null ''Default arguments passed to the sed command'';
          options =
            option
            ''
              ```lua
              {
                      ['ignore-case'] = {
                      	value= "--ignore-case",
                      	icon="[I]",
                      	desc="ignore case"
                      },
              }
              ```
            '';
        };
        "oxi" = {
          cmd = helpers.defaultNullOpts.mkStr "oxi";
          args = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''Default arguments passed to the oxi command'';
          options =
            option
            ''
              ```lua
              {
                      ['ignore-case'] = {
                      	value= "i",
                      	icon="[I]",
                      	desc="ignore case"
                      },
              }
              ```
            '';
        };
      };
      default = {
        find = {
          cmd = helpers.defaultNullOpts.mkStr "rg" "Must be one of the options in the findEngine";
          options = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[ignore-case]";
        };
        replace = {
          cmd = helpers.defaultNullOpts.mkStr "sed" "Must be one of the options in the replaceEngine";
          options = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]";
        };
      };
      replaceVimCmd = helpers.defaultNullOpts.mkStr "cdo";
      isOpenTargetWin = helpers.defaultNullOpts.mkBool true "Open file on opener window";
      isInsertMode = helpers.defaultNullOpts.mkBool false "If set to true will open window in insert mode";
      isBlockUIBreak = helpers.defaultNullOpts.mkBool false "If set to true will map backspace and enter key to avoid ui break";
      openTemplate =
        mkMappingsOption
        ''
                 ```lua
          { search_text = "text1", replace_text = "", path = "" }
          ```
        ''
        "An template to use on open function";
    };

  config = let
    cfg = config.plugins.spectre;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = let
        opts = with cfg; {
        };
      in ''
        require('spectre').setup(${helpers.toLuaObject opts})
      '';
    };
}
