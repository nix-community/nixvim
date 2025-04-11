{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "parrot";
  packPathName = "parrot.nvim";
  package = "parrot-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    dependencies.ripgrep.enable = lib.mkDefault true;
  };

  settingsExample = lib.literalExpression ''
    {
      cmd_prefix = "Parrot";
      providers = {
        github = {
          api_key.__raw = "os.getenv 'GITHUB_TOKEN'";
          topic.model = "gpt-4o";
        };
      };
      hooks = {
        Ask.__raw = '''
          function(parrot, params)
            local template = "Please, answer to this question: {{command}}."
            local model_obj = parrot.get_model("command")
            parrot.logger.info("Asking model: " .. model_obj.name)
            parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "🤖 Ask ~ ", template)
          end
        ''';
      };
    };
  '';
}
