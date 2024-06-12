{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "spectre";
  originalName = "nvim-spectre";
  defaultPackage = pkgs.vimPlugins.nvim-spectre;

  maintainers = [ maintainers.GaetanLepage ];

  description = ''
    You may want to set the package for your find/replace tool(s) like shown below:

    ```nix
      plugins.spectre.findPackage = pkgs.rg;
      plugins.spectre.replacePackage = pkgs.gnused;
    ```
  '';

  settingsOptions =
    let
      mkEngineOption =
        type:
        helpers.mkNullOrOption
          (
            with types;
            attrsOf (submodule {
              options = {
                cmd = mkOption {
                  type = types.str;
                  description = "Executable to run.";
                };

                args = helpers.defaultNullOpts.mkListOf types.str "[]" ''
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
                }) "{}" "The options for this engine.";
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

      highlight = helpers.defaultNullOpts.mkAttrsOf types.str ''
        {
          headers = "SpectreHeader";
          ui = "SpectreBody";
          filename = "SpectreFile";
          filedirectory = "SpectreDir";
          search = "SpectreSearch";
          border = "SpectreBorder";
          replace = "SpectreReplace";
        }
      '' "Highlight groups.";

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

          options = helpers.defaultNullOpts.mkListOf types.str ''["ignore-case"]'' ''
            Options to use for this engine.
          '';
        };

        replace = {
          cmd = helpers.defaultNullOpts.mkStr "rg" ''
            Which find engine to use. Pick one from the `replace_engine` list.
          '';

          options = helpers.defaultNullOpts.mkListOf types.str "[]" ''
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

  extraOptions =
    let
      userCommandSettings = config.plugins.spectre.settings.default;

      findPackages = {
        rg = pkgs.ripgrep;
      };

      replacePackages = {
        sed = pkgs.gnused;
        inherit (pkgs) sd;
      };

      # `toString` will turn `null` into `"null"` to allow for the attrs indexation.
      findDefaultPackage = findPackages.${toString userCommandSettings.find.cmd} or null;
      replaceDefaultPackage = replacePackages.${toString userCommandSettings.replace.cmd} or null;
    in
    {
      findPackage = helpers.mkPackageOption {
        default = findDefaultPackage;
        description = ''
          Which package to install for the find command.
          Defaults to `pkgs.$\{settings.default.find.cmd}`.

          Set to `null` to prevent the installation.
        '';
      };

      replacePackage = helpers.mkPackageOption {
        default = replaceDefaultPackage;
        description = ''
          Which package to install for the find command.
          Defaults to `pkgs.$\{settings.default.replace.cmd}`.

          Set to `null` to prevent the installation.
        '';
      };
    };

  extraConfig = cfg: {
    extraPackages = [
      cfg.findPackage
      cfg.replacePackage
    ];
  };
}
