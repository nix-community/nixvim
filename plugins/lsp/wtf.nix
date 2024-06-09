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
  };
in
{
  options = {
    plugins.wtf = helpers.neovim-plugin.extraOptionsOptions // {
      enable = mkEnableOption "wtf.nvim";

      package = helpers.mkPluginPackageOption "wtf.nvim" pkgs.vimPlugins.wtf-nvim;

      keymaps = mapAttrs (
        action: defaults:
        helpers.mkNullOrOption (
          with types; either str (helpers.keymaps.mkMapOptionSubmodule { inherit defaults; })
        ) "Keymap for the ${action} action."
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

      openaiApiKey = helpers.mkNullOrOption (with types; either str helpers.nixvimTypes.rawLua) ''
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

      keymaps = filter (keymap: keymap != null) (
        mapAttrsToList (
          action: value: if isString value then defaultKeymaps.${action} // { key = value; } else value
        ) cfg.keymaps
      );

      extraConfigLua = ''
        require("wtf").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
