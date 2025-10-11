{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "wtf";
  package = "wtf-nvim";
  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: introduced 2025-10-11: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;

  settingsExample = {
    popup_type = "popup";
    providers.openai = {
      api_key = lib.nixvim.nestedLiteralLua "vim.env.OPENAI_API_KEY";
      model_id = "gpt-3.5-turbo";
    };
    context = true;
    language = "english";
    search_engine = "phind";
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
  };
}
