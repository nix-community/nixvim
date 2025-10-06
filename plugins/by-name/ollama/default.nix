{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "ollama";
  package = "ollama-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: introduced 2025-10-06
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;

  settingsExample = {
    model = "mistral";
    action = "display";
    url = "http://127.0.0.1:11434";
    serve = {
      on_start = false;
      command = "ollama";
      args = [ "serve" ];
      stop_command = "pkill";
      stop_args = [
        "-SIGTERM"
        "ollama"
      ];
    };
    prompts = {
      my-prompt = {
        prompt = "Hello $input $sel. J'aime le fromage.";
        input_label = "> ";
        action = "display";
        model = "foo";
        extract = "```$ftype\n(.-)```";
        options = {
          mirostat_eta = 0.1;
          num_thread = 8;
          repeat_last_n = -1;
          stop = "arrêt";
        };
        system = "system";
        format = "json";
      };
    };
  };
}
