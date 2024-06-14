{
  lib,
  helpers,
  config,
  ...
}:
with lib;
let
  cfg = config.plugins.cmp-ai;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.cmp-ai = {
    settings = helpers.mkSettingsOption {
      description = "Options provided to the `require('cmp_ai.config'):setup` function.";

      options = {
        max_lines = helpers.defaultNullOpts.mkUnsignedInt 50 ''
          How many lines of buffer context to use.
        '';

        run_on_every_keystroke = helpers.defaultNullOpts.mkBool true ''
          Generate new completion items on every keystroke.
        '';

        provider = helpers.defaultNullOpts.mkStr "HF" ''
          Which AI provider to use.

          Check the [README](https://github.com/tzachar/cmp-ai/blob/main/README.md) to learn about
          available options.
        '';

        provider_options = helpers.defaultNullOpts.mkAttrsOf types.anything { } ''
          Options to forward to the provider.
        '';

        notify = helpers.defaultNullOpts.mkBool true ''
          As some completion sources can be quit slow, setting this to `true` will trigger a
          notification when a completion starts and ends using `vim.notify`.
        '';

        notify_callback = helpers.defaultNullOpts.mkLuaFn' {
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

        ignored_file_types = helpers.defaultNullOpts.mkAttrsOf' {
          type = types.bool;
          description = "Which filetypes to ignore.";
          pluginDefault = { };
          example = {
            lua = true;
            html = true;
          };
        };
      };

      example = {
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
    };
  };

  config = mkIf cfg.enable {
    extraConfigLua = ''
      require('cmp_ai.config'):setup(${helpers.toLuaObject cfg.settings})
    '';
  };
}
