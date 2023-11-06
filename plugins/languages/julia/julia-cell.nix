{
  lib,
  helpers,
  pkgs,
  config,
  ...
}: let
  cfg = config.plugins.julia-cell;

  # The keys are the option name in nixvim (under plugins.julia-cell.keymaps)
  # cmd: Such that the mapping action is ':JuliaCell${cmd}<CR>'
  # desc: The description of the option.
  mappings = {
    executeCell = {
      cmd = "ExecuteCell";
      desc = "executing the current code cell";
    };
    executeCellJump = {
      cmd = "ExecuteCellJump";
      desc = "executing the current code cell and jumping to the next cell";
    };
    run = {
      cmd = "Run";
      desc = "running the entire file";
    };
    clear = {
      cmd = "Clear";
      desc = "clearing the REPL";
    };
    prevCell = {
      cmd = "PrevCell";
      desc = "jumping to the previous cell header";
    };
    nextCell = {
      cmd = "NextCell";
      desc = "jumping to the next cell header";
    };
  };
in
  with lib; {
    options.plugins.julia-cell = {
      enable = mkEnableOption "julia-cell";

      package = helpers.mkPackageOption "julia-cell" pkgs.vimPlugins.vim-julia-cell;

      delimitCellsBy = helpers.defaultNullOpts.mkEnumFirstDefault ["marks" "tags"] ''
        Specifies if cells are delimited by 'marks' or 'tags'.
      '';

      tag = helpers.defaultNullOpts.mkStr "##" "Specifies the tag format.";

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          The configuration options for julia-cell without the 'julia_cell_' prefix.
          Example: To set 'julia_cell_foobar' to 1, write
          extraConfig = {
            foobar = true;
          };
        '';
      };

      keymaps =
        {
          silent = mkOption {
            type = types.bool;
            description = "Whether julia-cell keymaps should be silent";
            default = false;
          };
        }
        // (
          mapAttrs
          (
            name: value:
              helpers.mkNullOrOption types.str "Keymap for ${value.desc}."
          )
          mappings
        );
    };

    config = mkIf cfg.enable {
      extraPlugins = [cfg.package];

      globals =
        mapAttrs'
        (name: nameValuePair ("julia_cell_" + name))
        (
          {
            delimit_cells_by = cfg.delimitCellsBy;
            inherit (cfg) tag;
          }
          // cfg.extraConfig
        );

      keymaps = flatten (
        mapAttrsToList
        (
          name: value: let
            key = cfg.keymaps.${name};
          in
            optional
            (key != null)
            {
              mode = "n";
              inherit key;
              action = ":JuliaCell${value.cmd}<CR>";
              options.silent = cfg.keymaps.silent;
            }
        )
        mappings
      );
    };
  }
