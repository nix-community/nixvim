{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.wtf;

  defaultKeymaps = {
    ai = {
      key = "gw";
      mode = [
        "n"
        "x"
      ];
      action.__raw = "require('wtf').ai";
    };

    search = {
      key = "gW";
      mode = "n";
      action.__raw = "require('wtf').search";
    };

    history = {
      key = "wh";
      mode = "n";
      action.__raw = "require('wtf').history";
    };

    grep_history = {
      key = "wg";
      mode = "n";
      action.__raw = "require('wtf').grep_history";
    };
  };
in
{
  options = {
    plugins.wtf = lib.nixvim.plugins.neovim.extraOptionsOptions // {
      enable = mkEnableOption "wtf.nvim";

      package = lib.mkPackageOption pkgs "wtf.nvim" {
        default = [
          "vimPlugins"
          "wtf-nvim"
        ];
      };

      keymaps = mapAttrs (
        action: defaults:
        helpers.mkNullOrOption' {
          type =
            with types;
            coercedTo str (key: defaultKeymaps.${action} // { inherit key; }) (
              helpers.keymaps.mkMapOptionSubmodule {
                inherit defaults;
                lua = true;
              }
            );
          apply = v: if v == null then null else helpers.keymaps.removeDeprecatedMapAttrs v;
          description = "Keymap for the ${action} action.";
        }
      ) defaultKeymaps;

      popupType =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "popup"
            "horizontal"
            "vertical"
          ]
          ''
            Default AI popup type.
          '';

      openaiApiKey = helpers.defaultNullOpts.mkStr null ''
        An alternative way to set your API key.
      '';

      openaiModelId = helpers.defaultNullOpts.mkStr "gpt-3.5-turbo" "ChatGPT Model.";

      context = helpers.defaultNullOpts.mkBool true "Send code as well as diagnostics.";

      language = helpers.defaultNullOpts.mkStr "english" ''
        Set your preferred language for the response.
      '';

      additionalInstructions = helpers.mkNullOrOption types.str "Any additional instructions.";

      searchEngine = helpers.defaultNullOpts.mkEnumFirstDefault [
        "google"
        "duck_duck_go"
        "stack_overflow"
        "github"
      ] "Default search engine.";

      hooks = {
        requestStarted = helpers.defaultNullOpts.mkLuaFn "nil" "Callback for request start.";

        requestFinished = helpers.defaultNullOpts.mkLuaFn "nil" "Callback for request finished.";
      };

      winhighlight = helpers.defaultNullOpts.mkStr "Normal:Normal,FloatBorder:FloatBorder" ''
        Add custom colours.
      '';
    };
  };

  config =
    let
      setupOptions =
        with cfg;
        {
          popup_type = popupType;
          openai_api_key = openaiApiKey;
          openai_model_id = openaiModelId;
          inherit context language;
          additional_instructions = additionalInstructions;
          search_engine = searchEngine;
          hooks = {
            request_started = hooks.requestStarted;
            request_finished = hooks.requestFinished;
          };
          inherit winhighlight;
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      keymaps = filter (keymap: keymap != null) (attrValues cfg.keymaps);

      extraConfigLua = ''
        require("wtf").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
