{
  lib,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "chatgpt";
  package = "ChatGPT-nvim";
  description = "Effortless Natural Language Generation with OpenAI's ChatGPT API";

  maintainers = [ maintainers.GaetanLepage ];

  dependencies = [ "curl" ];

  # TODO: added 2025-04-06, remove after 25.05
  imports = [
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "chatgpt";
      packageName = "curl";
    })
  ];

  settingsOptions = {
    api_key_cmd = lib.nixvim.defaultNullOpts.mkStr null ''
      The path and arguments to an executable that returns the API key via stdout.
    '';

    yank_register = lib.nixvim.defaultNullOpts.mkStr "+" ''
      Which register to use for copying.
    '';

    extra_curl_params = lib.nixvim.defaultNullOpts.mkListOf' {
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

    show_line_numbers = lib.nixvim.defaultNullOpts.mkBool true ''
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
