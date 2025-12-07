{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "spectre";
  package = "nvim-spectre";
  description = "A search panel for neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies =
    let
      defaults = config.plugins.spectre.settings.default;
    in
    [
      {
        name = "ripgrep";
        enable = defaults.find.cmd == "rg";
      }
      {
        name = "sed";
        enable = defaults.replace.cmd == "sed";
      }
      {
        name = "sd";
        enable = defaults.replace.cmd == "sd";
      }
    ];

  settingsOptions =
    let
      mkEngineOption =
        type:
        lib.nixvim.mkNullOrOption
          (
            with types;
            attrsOf (submodule {
              freeformType = with types; attrsOf anything;
              options = {
                cmd = mkOption {
                  type = types.str;
                  description = "Executable to run.";
                };

                args = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
                  List of arguments to provide to the engine.
                '';

                options = lib.nixvim.defaultNullOpts.mkAttrsOf (types.submodule {
                  options = {
                    value = mkOption {
                      type = types.str;
                      example = "-i";
                      description = "The option flag.";
                    };

                    icon = mkOption {
                      type = types.str;
                      example = "[I]";
                      description = "The option icon.";
                    };

                    desc = lib.nixvim.mkNullOrStr ''
                      The description for this option.
                    '';
                  };
                }) { } "The options for this engine.";
              };
            })
          )
          ''
            Definition of the ${type} engines.

            default: see [here](https://github.com/nvim-pack/nvim-spectre/blob/master/lua/spectre/config.lua)
          '';
    in
    {
      color_devicons = lib.nixvim.defaultNullOpts.mkBool true ''
        Whether to enable color devicons.
      '';

      open_cmd = lib.nixvim.defaultNullOpts.mkStr "vnew" ''
        The open command.
      '';

      live_update = lib.nixvim.defaultNullOpts.mkBool false ''
        Auto execute search again when you write to any file in vim.
      '';

      lnum_for_results = lib.nixvim.defaultNullOpts.mkBool false ''
        Show line number for search/replace results.
      '';

      line_sep_start = lib.nixvim.defaultNullOpts.mkStr "┌──────────────────────────────────────────────────────" "Start of the line separator";

      result_padding = lib.nixvim.defaultNullOpts.mkStr "│  " ''
        Result padding string.
      '';

      line_sep = lib.nixvim.defaultNullOpts.mkStr "└──────────────────────────────────────────────────────" "Line separator.";

      highlight = lib.nixvim.defaultNullOpts.mkAttrsOf types.str {
        headers = "SpectreHeader";
        ui = "SpectreBody";
        filename = "SpectreFile";
        filedirectory = "SpectreDir";
        search = "SpectreSearch";
        border = "SpectreBorder";
        replace = "SpectreReplace";
      } "Highlight groups.";

      mapping =
        lib.nixvim.mkNullOrOption
          (
            with types;
            attrsOf (submodule {
              options = {
                map = mkOption {
                  type = types.str;
                  description = "Keyboard shortcut.";
                };

                cmd = mkOption {
                  type = types.str;
                  description = "Command to run.";
                  example = "<cmd>lua require('spectre').tab()<cr>";
                };

                desc = lib.nixvim.mkNullOrStr ''
                  Description for this mapping.
                '';
              };
            })
          )
          ''
            Keymaps declaration.

            default: see [here](https://github.com/nvim-pack/nvim-spectre/blob/master/lua/spectre/config.lua)
          '';

      find_engine = mkEngineOption "find";

      replace_engine = mkEngineOption "replace";

      default = {
        find = {
          cmd = lib.nixvim.defaultNullOpts.mkStr "rg" ''
            Which find engine to use. Pick one from the `find_engine` list.
          '';

          options = lib.nixvim.defaultNullOpts.mkListOf types.str [ "ignore-case" ] ''
            Options to use for this engine.
          '';
        };

        replace = {
          cmd = lib.nixvim.defaultNullOpts.mkStr "rg" ''
            Which find engine to use. Pick one from the `replace_engine` list.
          '';

          options = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
            Options to use for this engine.
          '';
        };
      };

      replace_vim_cmd = lib.nixvim.defaultNullOpts.mkStr "cdo" ''
        The replace command to use within vim.
      '';

      is_open_target_win = lib.nixvim.defaultNullOpts.mkBool true ''
        Open file on opener window.
      '';

      is_insert_mode = lib.nixvim.defaultNullOpts.mkBool false ''
        Start open panel in insert mode.
      '';

      is_block_ui_break = lib.nixvim.defaultNullOpts.mkBool false ''
        Mapping backspace and enter key to avoid ui break.
      '';
    };

  settingsExample = {
    live_update = true;
    is_insert_mode = false;
    find_engine = {
      rg = {
        cmd = "rg";
        args = [
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
        ];
        options = {
          ignore-case = {
            value = "--ignore-case";
            icon = "[I]";
            desc = "ignore case";
          };
          hidden = {
            value = "--hidden";
            desc = "hidden file";
            icon = "[H]";
          };
          line = {
            value = "-x";
            icon = "[L]";
            desc = "match in line";
          };
          word = {
            value = "-w";
            icon = "[W]";
            desc = "match in word";
          };
        };
      };
    };
    default = {
      find = {
        cmd = "rg";
        options = [
          "word"
          "hidden"
        ];
      };
      replace = {
        cmd = "sed";
      };
    };
  };
}
