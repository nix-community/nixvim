{
  empty = {
    plugins.ollama.enable = true;
  };

  example = {
    plugins.ollama = {
      enable = true;

      model = "mistral";
      prompts = {
        # disable prompt
        Sample_Prompt = false;
        my-prompt = {
          prompt = "Hello $input $sel. J'aime le fromage.";
          inputLabel = "> ";
          action = {
            fn = ''
              function(prompt)
                return function(body, job)
                end
              end
            '';
            opts.stream = true;
          };
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
      action = "display";
      url = "http://127.0.0.1:11434";
      serve = {
        onStart = false;
        command = "ollama";
        args = ["serve"];
        stopCommand = "pkill";
        stopArgs = ["-SIGTERM" "ollama"];
      };
    };
  };
}
