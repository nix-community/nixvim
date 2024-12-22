{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "chatgpt";
  packPathName = "ChatGPT.nvim";
  package = "ChatGPT-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  extraOptions = {
    curlPackage = lib.mkPackageOption pkgs "curl" {
      nullable = true;
    };
  };

  extraConfig = cfg: { extraPackages = [ cfg.curlPackage ]; };

  settingsOptions = {
    api_key_cmd = helpers.defaultNullOpts.mkStr null ''
      The path and arguments to an executable that returns the API key via stdout.
    '';

    yank_register = helpers.defaultNullOpts.mkStr "+" ''
      Which register to use for copying.
    '';

    extra_curl_params = helpers.defaultNullOpts.mkListOf' {
      type = types.str;
      pluginDefault = null;
      description = ''
        Custom cURL parameters can be passed using this option.
        It can be useful if you need to include additional headers for requests.
      '';
      example = [
        "-H"
        "Origin: https://example.com"
      ];
    };

    show_line_numbers = helpers.defaultNullOpts.mkBool true ''
      Whether to show line numbers in the ChatGPT window.
    '';
  };

  settingsExample = {
    welcome_message = "Hello world";
    loading_text = "loading";
    question_sign = "";
    answer_sign = "ﮧ";
    max_line_length = 120;
    yank_register = "+";
    chat_layout = {
      relative = "editor";
      position = "50%";
    };
    openai_params = {
      model = "gpt-3.5-turbo";
      frequency_penalty = 0;
      presence_penalty = 0;
      max_tokens = 300;
    };
    openai_edit_params = {
      model = "code-davinci-edit-001";
      temperature = 0;
    };
    keymaps = {
      close = [ "<C-c>" ];
      submit = "<C-s>";
    };
  };
}
