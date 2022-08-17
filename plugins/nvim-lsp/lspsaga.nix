{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lspsaga;
  helpers = import ../helpers.nix { inherit lib config; };
in with helpers;
{
  options = {
    programs.nixvim.plugins.lspsaga = {
      enable = mkEnableOption "Enable lspsava.nvim";

      signs = {
        use = mkOption {
          default = true;
          type = types.bool;
          description = "Whether to use diagnostic signs";
        };

        error = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Error diagnostic sign";
        };

        warning = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Warning diagnostic sign";
        };

        hint = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Hint diagnostic sign";
        };

        info = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Info diagnostic sign";
        };
      };

      headers = {
        error = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Error diagnostic header";
        };

        warning = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Warning diagnostic header";
        };

        hint = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Hint diagnostic header";
        };

        info = mkOption {
          type = types.nullOr types.str;
          default = "  Info";
          description = "Info diagnostic header";
        };
      };

      maxDialogWidth = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Maximum dialog width";
      };

      icons = {
        codeAction = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Code action icon";
        };

        findDefinition = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Find definition icon";
        };

        findReference = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Find reference icon";
        };

        definitionPreview = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Definition preview icon";
        };
      };

      maxFinderPreviewLines = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Maximum finder preview lines";
      };

      keys = let
        defaultKeyOpt = desc: mkOption {
          description = desc;
          type = types.nullOr types.str;
          default = null;
        };
      in {
        finderAction = {
          open = defaultKeyOpt "Open from finder";
          vsplit = defaultKeyOpt "Vertical split in finder";
          split = defaultKeyOpt "Horizontal split in finder";
          quit = defaultKeyOpt "Quit finder";
          scrollDown = defaultKeyOpt "Scroll down finder";
          scrollUp = defaultKeyOpt "Scroll up finder";
        };

        codeAction = {
          quit = defaultKeyOpt "Quit code actions menu";
          exec = defaultKeyOpt "Execute code action";
        };
      };

      codeActionPrompt = {
        enable = boolOption true "Enable code_action_prompt";
        sign = boolOption true "Display sign";
        enableInInsert = boolOption true "Enable prompt in inset mode";
        signPriority = intOption 20 "Priority of prompt (?)";
        virtualText = boolOption true "Use neovims virtual text feature";
      };

      borderStyle = mkOption {
        type = types.nullOr (types.enum [ "single" "round" "plus" "double" "bold" ]);
        default = null;
        description = "Border style";
      };

      renamePromptPrefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Rename prompt prefix";
      };
    };
  };

  config.programs.nixvim = let
    notDefault = default: opt: if (opt != default) then opt else null;
    notEmpty = opt: if ((filterAttrs (_: v: v != null) opt) != {}) then opt else null;
    notNull = opt: opt;
    lspsagaConfig = {
      use_saga_diagnostic_sign = notDefault true cfg.signs.use;
      error_sign = notNull cfg.signs.error;
      warn_sign = notNull cfg.signs.warning;
      hint_sign = notNull cfg.signs.hint;
      infor_sign = notNull cfg.signs.info;

      # TODO Fix this!
      # error_header = notNull cfg.headers.error;
      # warn_header = notNull cfg.headers.warning;
      # hint_header = notNull cfg.headers.hint;
      # infor_header = notNull cfg.headers.info;

      max_diag_msg_width = notNull cfg.maxDialogWidth;

      code_action_icon = notNull cfg.icons.codeAction;
      finder_definition_icon = notNull cfg.icons.findDefinition;
      finder_reference_icon = notNull cfg.icons.findReference;
      definition_preview_icon = notNull cfg.icons.definitionPreview;

      max_finder_preview_lines = notNull cfg.maxFinderPreviewLines;

      rename_prompt_prefix = notNull cfg.renamePromptPrefix;

      border_style = cfg.borderStyle;

      code_action_prompt = notEmpty {
        enable = notNull cfg.codeActionPrompt.enable;
        sign = notNull cfg.codeActionPrompt.sign;
        enable_in_insert = notNull cfg.codeActionPrompt.enableInInsert;
        sign_priority = notNull cfg.codeActionPrompt.signPriority;
        virtual_text = notNull cfg.codeActionPrompt.virtualText;
      };

      finder_action_keys = let
        keys = {
          open = notNull cfg.keys.finderAction.open;
          vsplit = notNull cfg.keys.finderAction.vsplit;
          split = notNull cfg.keys.finderAction.split;
          quit = notNull cfg.keys.finderAction.quit;
          scroll_down = notNull cfg.keys.finderAction.scrollDown;
          scroll_up = notNull cfg.keys.finderAction.scrollUp;
        };
      in notEmpty keys;

      code_action_keys = let
        keys = {
          quit = notNull cfg.keys.codeAction.quit;
          exec = notNull cfg.keys.codeAction.exec;
        };
      in notEmpty keys;
    };
  in mkIf cfg.enable {
    extraPlugins = [ pkgs.vimPlugins.lspsaga-nvim ];
    
    extraConfigLua = ''
      require("lspsaga").init_lsp_saga(${helpers.toLuaObject lspsagaConfig})
    '';
  };
}
