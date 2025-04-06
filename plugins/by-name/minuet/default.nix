{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "minuet";
  packPathName = "minuet-ai.nvim";
  package = "minuet-ai-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # Register nvim-cmp association
  imports = [
    { cmpSourcePlugins.minuet = "minuet"; }
  ];

  settingsExample = {
    provider = "openai_compatible";
    provider_options = {
      openai_compatible = {
        api_key = "OPENROUTER_API_KEY";
        end_point = "https://openrouter.ai/api/v1/chat/completions";
        name = "OpenRouter";
        model = "google/gemini-flash-1.5";
        stream = true;
        optional = {
          max_tokens = 256;
          top_p = 0.9;
        };
      };
    };
  };
}
