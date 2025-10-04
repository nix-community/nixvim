{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blame-nvim";
  moduleName = "blame";
  description = "fugitive.vim-style `git blame` visualizer for Neovim";

  maintainers = [ lib.maintainers.axka ];

  settingsOptions = {
    date_format = defaultNullOpts.mkStr "%d.%m.%Y" ''
      Date format string, `%r` for relative date.
    '';

    virtual_style = defaultNullOpts.mkEnumFirstDefault [
      "right_align"
      "float"
    ] "Float moves the virtual text close to the content of the file.";

    relative_date_if_recent = defaultNullOpts.mkBool true ''
      Whether to always show relative date if the it was less than 1 month ago.
    '';

    views = defaultNullOpts.mkNullable' {
      type = lib.types.attrsOf lib.types.strLuaFn;
      pluginDefault = lib.nixvim.literalLua ''
        {
          window = require("blame.views.window_view"),
          virtual = require("blame.views.virtual_view"),
          default = require("blame.views.window_view"),
        }
      '';
      description = ''
        Views that can be used when toggling blame.

        See [the plugin's documentation](https://github.com/FabijanZulj/blame.nvim#custom-views) for more information.
      '';
    };

    focus_blame = defaultNullOpts.mkBool true ''
      Whether to focus on the blame window when it's opened as well as blame stack push/pop.
    '';

    merge_consecutive = defaultNullOpts.mkBool false ''
      Merge consecutive blames that are from the same commit.
    '';

    max_summary_width = defaultNullOpts.mkUnsignedInt 30 ''
      If `date_message` is used as `format_fn`, cut the summary if it exceeds this number of characters.
    '';

    colors = defaultNullOpts.mkNullable (lib.types.listOf lib.types.str) null ''
      List of colors to use for highlights. If `null`, will use random RGB.

      Format is the same as in `:help nvim_set_hl()`.
    '';

    blame_options = defaultNullOpts.mkNullable (lib.types.listOf lib.types.str) null ''
      List of blame options to use for git blame. If `null` will use no options.
    '';

    commit_detail_view = defaultNullOpts.mkNullable' {
      type = lib.types.either (lib.types.enum [
        "tab"
        "split"
        "vsplit"
        "current"
      ]) lib.types.strLuaFn;
      pluginDefault = "vsplit";
      description = ''
        Where to open commit details.

        Function signature: `function(commit_hash, current_row, file_path) ... end`.
      '';
    };

    format_fn = defaultNullOpts.mkNullable' {
      type = lib.types.strLuaFn;
      pluginDefault = lib.nixvim.literalLua ''
        require("blame.formats.default_formats").commit_date_author_fn
        -- Basically {hash} {date} {author}
      '';
      example = lib.nixvim.literalLua ''
        require("blame.formats.default_formats").date_message
        -- Basically {date} {message summary}
      '';
      description = ''
        Function that is used for processing of porcelain lines.

        See [the plugin's documentation](https://github.com/FabijanZulj/blame.nvim#custom-format-function) for more information.
      '';
    };

    mappings =
      let
        mappingType = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
        mkMappingOption = defaultNullOpts.mkNullable mappingType;
      in
      lib.mkOption {
        default = { };
        description = ''
          Mappings for various actions **in the window view**.
        '';
        type = lib.types.submodule {
          freeformType = lib.types.attrsOf mappingType;
          options = {
            commit_info = mkMappingOption "i" ''
              Mapping to show information about the commit under the cursor.
            '';

            stack_push = mkMappingOption "<TAB>" ''
              Mapping to show the state of the file prior to the commit under the cursor.
            '';

            stack_pop = mkMappingOption "<BS>" ''
              Mapping to show a latter the state of the file, after using `stack_push`.
            '';

            show_commit = mkMappingOption "<CR>" ''
              Mapping to show detailed information about the commit under the cursor at `commit_detail_view`.
            '';

            close = mkMappingOption [ "<esc>" "q" ] ''
              Mapping to close the window view.
            '';
          };
        };
      };
  };

  settingsExample = lib.literalExpression ''
    {
      date_format = "%Y-%m-%d";
      views.default = lib.nixvim.mkRaw '''
        require("blame.views.virtual_view")
      ''';
      format_fn = lib.nixvim.mkRaw '''
        require("blame.formats.default_formats").date_message
      ''';
      colors = [ "Pink" "Aqua" "#ffffff" ];
    }
  '';
}
