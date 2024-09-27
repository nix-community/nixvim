{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.startup;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.startup = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "startup.nvim";

    package = lib.mkPackageOption pkgs "startup.nvim" {
      default = [
        "vimPlugins"
        "startup-nvim"
      ];
    };

    theme = helpers.defaultNullOpts.mkStr "dashboard" ''
      Use a pre-defined theme.
    '';

    sections =
      let
        sectionType =
          with types;
          submodule {
            options = {
              type =
                helpers.defaultNullOpts.mkEnumFirstDefault
                  [
                    "text"
                    "mapping"
                    "oldfiles"
                  ]
                  ''
                    - "text" -> text that will be displayed
                    - "mapping" -> create mappings for commands that can be used.
                      use `mappings.executeCommand` on the commands to execute.
                    - "oldfiles" -> display oldfiles (can be opened with `mappings.openFile`/`openFileSplit`)
                  '';

              oldfilesDirectory = helpers.defaultNullOpts.mkBool false ''
                if the oldfiles of the current directory should be displayed.
              '';

              align =
                helpers.defaultNullOpts.mkEnumFirstDefault
                  [
                    "center"
                    "left"
                    "right"
                  ]
                  ''
                    How to align the section.
                  '';

              foldSection = helpers.defaultNullOpts.mkBool false ''
                Whether to fold or not.
              '';

              title = helpers.defaultNullOpts.mkStr "title" ''
                Title for the folded section.
              '';

              margin =
                helpers.defaultNullOpts.mkNullable (with types; either (numbers.between 0.0 1.0) ints.positive) 5
                  ''
                    The margin for left or right alignment.
                    - if < 1 fraction of screen width
                    - if > 1 numbers of column
                  '';

              content =
                helpers.mkNullOrOption
                  (
                    with types;
                    oneOf [
                      # for "text" "mapping"
                      (listOf (either str (listOf str)))
                      rawLua
                      # for "oldfiles" sections
                      (enum [ "" ])
                    ]
                  )
                  ''
                    The type of `content` depends on the section `type`:
                    - "text" -> a list of strings or a function (`rawLua`) that requires a function that returns a table of strings
                    - "mapping" -> a list of list of strings in the format:
                      ```nix
                        [
                          [<displayed_command_name> <command> <mapping>]
                          [<displayed_command_name> <command> <mapping>]
                        ]
                      ```
                      Example: `[" Find File" "Telescope find_files" "<leader>ff"]`
                    - "oldfiles" -> `""`
                  '';

              highlight = helpers.mkNullOrOption types.str ''
                Highlight group in which the section text should be highlighted.
              '';

              defaultColor = helpers.defaultNullOpts.mkStr "#FF0000" ''
                A hex color that gets used if you don't specify `highlight`.
              '';

              oldfilesAmount = helpers.defaultNullOpts.mkUnsignedInt 5 ''
                The amount of oldfiles to be displayed.
              '';
            };
          };
      in
      mkOption {
        type = with types; attrsOf sectionType;
        default = { };
        description = '''';
        example = {
          header = {
            type = "text";
            align = "center";
            foldSection = false;
            title = "Header";
            margin = 5;
            content.__raw = "require('startup.headers').hydra_header";
            highlight = "Statement";
            defaultColor = "";
            oldfilesAmount = 0;
          };
          body = {
            type = "mapping";
            align = "center";
            foldSection = true;
            title = "Basic Commands";
            margin = 5;
            content = [
              [
                " Find File"
                "Telescope find_files"
                "<leader>ff"
              ]
              [
                "󰍉 Find Word"
                "Telescope live_grep"
                "<leader>lg"
              ]
              [
                " Recent Files"
                "Telescope oldfiles"
                "<leader>of"
              ]
              [
                " File Browser"
                "Telescope file_browser"
                "<leader>fb"
              ]
              [
                " Colorschemes"
                "Telescope colorscheme"
                "<leader>cs"
              ]
              [
                " New File"
                "lua require'startup'.new_file()"
                "<leader>nf"
              ]
            ];
            highlight = "String";
            defaultColor = "";
            oldfilesAmount = 0;
          };
        };
      };

    options = {
      mappingKeys = helpers.defaultNullOpts.mkBool true ''
        Display mapping (e.g. `<leader>ff`).
      '';

      cursorColumn =
        helpers.defaultNullOpts.mkNullable (with types; either (numbers.between 0.0 1.0) ints.positive) 0.5
          ''
            - if < 1, fraction of screen width
            - if > 1 numbers of column
          '';

      after = helpers.defaultNullOpts.mkLuaFn "nil" ''
        A function that gets executed at the end.
      '';

      emptyLinesBetweenMappings = helpers.defaultNullOpts.mkBool true ''
        Add an empty line between mapping/commands.
      '';

      disableStatuslines = helpers.defaultNullOpts.mkBool true ''
        Disable status-, buffer- and tablines.
      '';

      paddings = helpers.defaultNullOpts.mkListOf types.ints.unsigned [ ] ''
        Amount of empty lines before each section (must be equal to amount of sections).
      '';
    };

    mappings = {
      executeCommand = helpers.defaultNullOpts.mkStr "<CR>" ''
        Keymapping to execute a command.
      '';

      openFile = helpers.defaultNullOpts.mkStr "o" ''
        Keymapping to open a file.
      '';

      openFileSplit = helpers.defaultNullOpts.mkStr "<c-o>" ''
        Keymapping to open a file in a split.
      '';

      openSection = helpers.defaultNullOpts.mkStr "<TAB>" ''
        Keymapping to open a section.
      '';

      openHelp = helpers.defaultNullOpts.mkStr "?" ''
        Keymapping to open help.
      '';
    };

    colors = {
      background = helpers.defaultNullOpts.mkStr "#1f2227" ''
        The background color.
      '';

      foldedSection = helpers.defaultNullOpts.mkStr "#56b6c2" ''
        The color of folded sections.
        This can also be changed with the `StartupFoldedSection` highlight group.
      '';
    };

    parts = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "List all sections in order.";
      example = [
        "section_1"
        "section_2"
      ];
    };

    userMappings = mkOption {
      type = with types; attrsOf str;
      description = "Add your own mappings as key-command pairs.";
      default = { };
      example = {
        "<leader>ff" = "<cmd>Telescope find_files<CR>";
        "<leader>lg" = "<cmd>Telescope live_grep<CR>";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      let
        sectionNames = attrNames cfg.sections;
        numSections = length sectionNames;
      in
      [
        {
          assertion = (cfg.options.paddings == null) || (length cfg.options.paddings) == numSections;
          message = ''
            Nixvim (plugins.startup): Make sure that `plugins.startup.options.paddings` has the same
            number of elements as there are sections.
          '';
        }
        {
          assertion =
            ((length cfg.parts) <= numSections) && (all (part: hasAttr part cfg.sections) cfg.parts);
          message = ''
            Nixvim (plugins.startup): You should not have more section names in `plugins.startup.parts` than you have sections defined.
          '';
        }
      ];
    extraPlugins = [ cfg.package ];

    extraConfigLua =
      let
        sections = mapAttrs (
          name: sectionAttrs: with sectionAttrs; {
            inherit type;
            oldfiles_directory = oldfilesDirectory;
            inherit align;
            fold_section = foldSection;
            inherit
              title
              margin
              content
              highlight
              ;
            default_color = defaultColor;
            oldfiles_amount = oldfilesAmount;
          }
        ) cfg.sections;

        options =
          with cfg.options;
          {
            mapping_keys = mappingKeys;
            cursor_column = cursorColumn;
            inherit after;
            empty_lines_between_mappings = emptyLinesBetweenMappings;
            disable_statuslines = disableStatuslines;
            inherit paddings;
          }
          // cfg.extraOptions;

        setupOptions = {
          inherit (cfg) theme;
          inherit options;
          mappings = with cfg.mappings; {
            execute_command = executeCommand;
            open_file = openFile;
            open_file_split = openFileSplit;
            open_section = openSection;
            open_help = openHelp;
          };
          colors = with cfg.colors; {
            inherit background;
            folded_section = foldedSection;
          };
          inherit (cfg) parts;
        } // sections;
      in
      ''
        require('startup').setup(${helpers.toLuaObject setupOptions})
      ''
      + (optionalString (
        cfg.userMappings != { }
      ) "require('startup').create_mappings(${helpers.toLuaObject cfg.userMappings})");
  };
}
