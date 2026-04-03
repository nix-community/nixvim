{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "model";
  package = "model-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
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
}
