{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cmp-ai";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports = [
    { cmpSourcePlugins.cmp_ai = "cmp-ai"; }
  ];

  moduleName = "cmp_ai.config";
  setup = ":setup";

  settingsOptions = {
    max_lines = defaultNullOpts.mkUnsignedInt 50 ''
      How many lines of buffer context to use.
    '';

    run_on_every_keystroke = defaultNullOpts.mkBool true ''
      Generate new completion items on every keystroke.
    '';

    provider = defaultNullOpts.mkStr "HF" ''
      Which AI provider to use.

      Check the [README](https://github.com/tzachar/cmp-ai/blob/main/README.md) to learn about
      available options.
    '';

    provider_options = defaultNullOpts.mkAttrsOf lib.types.anything { } ''
      Options to forward to the provider.
    '';

    notify = defaultNullOpts.mkBool true ''
      As some completion sources can be quit slow, setting this to `true` will trigger a
      notification when a completion starts and ends using `vim.notify`.
    '';

    notify_callback = defaultNullOpts.mkLuaFn' {
      description = ''
        The default notify function uses `vim.notify`, but an override can be configured.
      '';
      pluginDefault = ''
        function(msg)
          vim.notify(msg)
        end
      '';
      example = ''
        function(msg)
          require('notify').notify(msg, vim.log.levels.INFO, {
            title = 'OpenAI',
            render = 'compact',
          })
        end
      '';
    };

    ignored_file_types = defaultNullOpts.mkAttrsOf' {
      type = lib.types.bool;
      description = "Which filetypes to ignore.";
      pluginDefault = { };
      example = {
        lua = true;
        html = true;
      };
    };
  };

  settingsExample = {
    max_lines = 1000;
    provider = "HF";
    notify = true;
    notify_callback = ''
      function(msg)
        vim.notify(msg)
      end
    '';
    run_on_every_keystroke = true;
    ignored_file_types = {
      lua = true;
    };
  };
}
