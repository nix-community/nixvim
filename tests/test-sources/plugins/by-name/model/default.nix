{
  empty = {
    plugins.model.enable = true;
  };

  example = {
    plugins.model = {
      enable = true;

      settings = {
        prompts = {
          zephyr = {
            provider.__raw = "require('model.providers.llamacpp')";
            options.url = "http:localhost:8080";

            builder.__raw = ''
              function(input, context)
                return {
                  prompt =
                    '<|system|>'
                    .. (context.args or 'You are a helpful assistant')
                    .. '\n</s>\n<|user|>\n'
                    .. input
                    .. '</s>\n<|assistant|>',
                  stop = { '</s>' }
                }
              end
            '';
          };
        };
      };
    };
  };

  defaults = {
    plugins.model = {
      enable = true;

      settings = {
        default_prompt.__raw = "require('model.providers.openai').default_prompt";
        prompts.__raw = "require('model.prompts.starters')";
        chats.__raw = "require('model.prompts.chats')";
      };
    };
  };
}
