{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.neogen;

  keymapDef = {
    generate = {
      command = "";

      description = ''
        The only function required to use Neogen.

        It'll try to find the first parent that matches a certain type.
        For example, if you are inside a function, and called `generate({ type = "func" })`,
        Neogen will go until the start of the function and start annotating for you.
      '';
    };

    generateClass = {
      command = "class";
      description = "Generates annotation for class.";
    };

    generateFunction = {
      command = "func";
      description = "Generates annotation for function.";
    };

    generateType = {
      command = "type";
      description = "Generates annotation for type.";
    };

    generateFile = {
      command = "file";
      description = "Generates annotation for file.";
    };
  };
in
{
  options.plugins.neogen = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption "neogen";

    package = lib.mkPackageOption pkgs "neogen" {
      default = [
        "vimPlugins"
        "neogen"
      ];
    };

    keymaps = mapAttrs (
      optionsName: properties: helpers.mkNullOrOption types.str properties.description
    ) keymapDef;

    keymapsSilent = mkOption {
      type = types.bool;
      description = "Whether Neogen keymaps should be silent";
      default = false;
    };

    inputAfterComment = helpers.defaultNullOpts.mkBool true ''
      If true, go to annotation after insertion, and change to insert mode
    '';

    enablePlaceholders = helpers.defaultNullOpts.mkBool true ''
      If true, enables placeholders when inserting annotation
    '';

    languages = helpers.defaultNullOpts.mkAttrsOf' {
      # No plugin default (see upstream)
      type = types.anything;
      description = ''
        Configuration for languages.

        `template.annotation_convention` (default: check the language default configurations):
          Change the annotation convention to use with the language.

        `template.use_default_comment` (default: true):
          Prepend any template line with the default comment for the filetype

        `template.position` (fun(node: userdata, type: string):(number,number)?):
          Provide an absolute position for the annotation.
          If return values are nil, use default position

        `template.append`:
          If you want to customize the position of the annotation.

        `template.append.child_name`:
          What child node to use for appending the annotation.

        `template.append.position` (before/after):
          Relative positioning with `child_name`.

        `template.<convention_name>` (replace <convention_name> with an annotation convention):
          Template for an annotation convention.
          To know more about how to create your own template, go here:
          https://github.com/danymat/neogen/blob/main/docs/adding-languages.md#default-generator
      '';
      example = {
        csharp = {
          template = {
            annotation_convention = "...";
          };
        };
      };
    };

    snippetEngine = helpers.mkNullOrOption types.str ''
      Use a snippet engine to generate annotations.
      Some snippet engines come out of the box bundled with neogen:
        - `"luasnip"` (https://github.com/L3MON4D3/LuaSnip)
        - `"snippy"` (https://github.com/dcampos/nvim-snippy)
        - `"vsnip"` (https://github.com/hrsh7th/vim-vsnip)
    '';

    placeholderHighlight = helpers.defaultNullOpts.mkStr "DiagnosticHint" ''
      Placeholders highlights to use. If you don't want custom highlight, pass "None"
    '';

    placeholdersText = {
      description = helpers.defaultNullOpts.mkStr "[TODO:description]" ''
        Placeholder for description.
      '';

      tparam = helpers.defaultNullOpts.mkStr "[TODO:tparam]" ''
        Placeholder for tparam.
      '';

      parameter = helpers.defaultNullOpts.mkStr "[TODO:parameter]" ''
        Placeholder for parameter.
      '';

      return = helpers.defaultNullOpts.mkStr "[TODO:return]" ''
        Placeholder for return.
      '';

      class = helpers.defaultNullOpts.mkStr "[TODO:class]" ''
        Placeholder for class.
      '';

      throw = helpers.defaultNullOpts.mkStr "[TODO:throw]" ''
        Placeholder for throw.
      '';

      varargs = helpers.defaultNullOpts.mkStr "[TODO:varargs]" ''
        Placeholder for varargs.
      '';

      type = helpers.defaultNullOpts.mkStr "[TODO:type]" ''
        Placeholder for type.
      '';

      attribute = helpers.defaultNullOpts.mkStr "[TODO:attribute]" ''
        Placeholder for attribute.
      '';

      args = helpers.defaultNullOpts.mkStr "[TODO:args]" ''
        Placeholder for args.
      '';

      kwargs = helpers.defaultNullOpts.mkStr "[TODO:kwargs]" ''
        Placeholder for kwargs.
      '';
    };
  };

  # TODO introduced 2024-03-07: remove 2024-05-07
  imports = [
    (mkRenamedOptionModule
      [
        "plugins"
        "neogen"
        "placeholderHighligt"
      ]
      [
        "plugins"
        "neogen"
        "placeholderHighlight"
      ]
    )
  ];

  config =
    let
      setupOptions = with cfg; {
        enabled = enable;
        input_after_comment = inputAfterComment;
        inherit languages;
        snippet_engine = snippetEngine;
        enable_placeholders = enablePlaceholders;
        placeholder_text = placeholdersText;
        placeholder_hl = placeholderHighlight;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("neogen").setup(${lib.nixvim.toLuaObject setupOptions})
      '';

      keymaps = flatten (
        mapAttrsToList (
          optionName: properties:
          let
            key = cfg.keymaps.${optionName};
          in
          optional (key != null) {
            mode = "n";
            inherit key;
            action = ":Neogen ${properties.command}<CR>";
            options.silent = cfg.keymapsSilent;
          }
        ) keymapDef
      );
    };
}
