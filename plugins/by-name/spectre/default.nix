{
  lib,
  config,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "spectre";
  package = "nvim-spectre";
  description = "A search panel for neovim.";

  maintainers = [ maintainers.GaetanLepage ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "spectre";
      packageName = "ripgrep";
      oldPackageName = "find";
    })
    (lib.mkRemovedOptionModule [ "plugins" "spectre" "replacePackage" ] ''
      If you have set `plugins.spectre.settings.default.find.cmd` to "sed" (or "sd" respectively), Nixvim will automatically enable `dependencies.sed.enable` (or `sd` respectively).

      - If you want to disable automatic installation of the replace tool, set `dependencies.s[e]d.enable` to `false`.
      - If you want to override which package is installed by Nixvim, set the `dependencies.s[e]d.package` option.
    '')
  ];

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
        helpers.mkNullOrOption
          (
            with types;
            attrsOf (submodule {
              freeformType = with types; attrsOf anything;
              options = {
                cmd = mkOption {
                  type = types.str;
                  description = "Executable to run.";
                };

                args = helpers.defaultNullOpts.mkListOf types.str [ ] ''
                  List of arguments to provide to the engine.
                '';

                options = helpers.defaultNullOpts.mkAttrsOf (types.submodule {
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

                    desc = helpers.mkNullOrStr ''
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
      color_devicons = helpers.defaultNullOpts.mkBool true ''
        Whether to enable color devicons.
      '';

      open_cmd = helpers.defaultNullOpts.mkStr "vnew" ''
        The open command.
      '';

      live_update = helpers.defaultNullOpts.mkBool false ''
        Auto execute search again when you write to any file in vim.
      '';

      lnum_for_results = helpers.defaultNullOpts.mkBool false ''
        Show line number for search/replace results.
      '';

      line_sep_start = helpers.defaultNullOpts.mkStr "┌──────────────────────────────────────────────────────" "Start of the line separator";

      result_padding = helpers.defaultNullOpts.mkStr "│  " ''
        Result padding string.
      '';

      line_sep = helpers.defaultNullOpts.mkStr "└──────────────────────────────────────────────────────" "Line separator.";

      highlight = helpers.defaultNullOpts.mkAttrsOf types.str {
        headers = "SpectreHeader";
        ui = "SpectreBody";
        filename = "SpectreFile";
        filedirectory = "SpectreDir";
        search = "SpectreSearch";
        border = "SpectreBorder";
        replace = "SpectreReplace";
      } "Highlight groups.";

      mapping =
        helpers.mkNullOrOption
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

                desc = helpers.mkNullOrStr ''
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
          cmd = helpers.defaultNullOpts.mkStr "rg" ''
            Which find engine to use. Pick one from the `find_engine` list.
          '';

          options = helpers.defaultNullOpts.mkListOf types.str [ "ignore-case" ] ''
            Options to use for this engine.
          '';
        };

        replace = {
          cmd = helpers.defaultNullOpts.mkStr "rg" ''
            Which find engine to use. Pick one from the `replace_engine` list.
          '';

          options = helpers.defaultNullOpts.mkListOf types.str [ ] ''
            Options to use for this engine.
          '';
        };
      };

      replace_vim_cmd = helpers.defaultNullOpts.mkStr "cdo" ''
        The replace command to use within vim.
      '';

      is_open_target_win = helpers.defaultNullOpts.mkBool true ''
        Open file on opener window.
      '';

      is_insert_mode = helpers.defaultNullOpts.mkBool false ''
        Start open panel in insert mode.
      '';

      is_block_ui_break = helpers.defaultNullOpts.mkBool false ''
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
