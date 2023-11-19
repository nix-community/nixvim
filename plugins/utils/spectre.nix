{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; {
  options.plugins.spectre = let
    mkMappingsOption = defaults:
      helpers.defaultNullOpts.mkNullable
      (with types; attrsOf attrs)
      defaults
      "Mapping options";
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
        mkMappingsOption
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
    };

  config = let
    cfg = config.plugins.refactoring;
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
