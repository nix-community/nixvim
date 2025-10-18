{
  lib,
  helpers,
  ...
}:
let
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
with lib;
lib.nixvim.plugins.mkVimPlugin {
  name = "julia-cell";
  package = "vim-julia-cell";
  globalPrefix = "julia_cell_";
  description = "A Vim plugin for executing Julia code cells.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    delimit_cells_by =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "marks"
          "tags"
        ]
        ''
          Specifies if cells are delimited by 'marks' or 'tags'.
        '';

    tag = helpers.defaultNullOpts.mkStr "##" "Specifies the tag format.";
  };

  extraOptions = {
    keymaps = {
      silent = mkOption {
        type = types.bool;
        description = "Whether julia-cell keymaps should be silent";
        default = false;
      };
    }
    // (mapAttrs (name: value: helpers.mkNullOrOption types.str "Keymap for ${value.desc}.") mappings);
  };

  extraConfig = cfg: {
    keymaps = flatten (
      mapAttrsToList (
        name: value:
        let
          key = cfg.keymaps.${name};
        in
        optional (key != null) {
          mode = "n";
          inherit key;
          action = ":JuliaCell${value.cmd}<CR>";
          options.silent = cfg.keymaps.silent;
        }
      ) mappings
    );
  };
}
