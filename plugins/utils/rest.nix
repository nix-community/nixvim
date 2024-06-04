{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "rest";
    originalName = "rest.nvim";
    luaName = "rest-nvim";
    defaultPackage = pkgs.vimPlugins.rest-nvim;

    extraPackages = [pkgs.curl];

    maintainers = [maintainers.GaetanLepage];

    # TODO introduced 2024-04-07: remove 2024-06-07
    deprecateExtraOptions = true;
    optionsRenamedToSettings = [
      "envFile"
      "encodeUrl"
      "skipSslVerification"
      "customDynamicVariables"
      [
        "highlight"
        "timeout"
      ]
    ];
    imports = let
      basePluginPath = [
        "plugins"
        "rest"
      ];
      settingsPath = basePluginPath ++ ["settings"];
    in [
      (mkRenamedOptionModule (basePluginPath ++ ["resultSplitHorizontal"]) (
        settingsPath
        ++ [
          "result"
          "split"
          "horizontal"
        ]
      ))
      (mkRenamedOptionModule (basePluginPath ++ ["resultSplitInPlace"]) (
        settingsPath
        ++ [
          "result"
          "split"
          "in_place"
        ]
      ))
      (mkRenamedOptionModule (basePluginPath ++ ["stayInCurrentWindowAfterSplit"]) (
        settingsPath
        ++ [
          "result"
          "split"
          "stay_in_current_window_after_split"
        ]
      ))
      (
        mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "result"
            "showUrl"
          ]
        )
        (
          settingsPath
          ++ [
            "result"
            "behavior"
            "show_info"
            "url"
          ]
        )
      )
      (
        mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "result"
            "showHeaders"
          ]
        )
        (
          settingsPath
          ++ [
            "result"
            "behavior"
            "show_info"
            "headers"
          ]
        )
      )
      (
        mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "result"
            "showHttpInfo"
          ]
        )
        (
          settingsPath
          ++ [
            "result"
            "behavior"
            "show_info"
            "http_info"
          ]
        )
      )
      (
        mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "result"
            "showCurlCommand"
          ]
        )
        (
          settingsPath
          ++ [
            "result"
            "behavior"
            "show_info"
            "curl_command"
          ]
        )
      )
      (
        mkRemovedOptionModule
        (
          basePluginPath
          ++ [
            "result"
            "showStatistics"
          ]
        )
        ''
          Use `plugins.rest.settings.result.behavior.statistics.{enable,stats}` instead.
          Refer to the documentation for more information.
        ''
      )
      (
        mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "result"
            "formatters"
          ]
        )
        (
          settingsPath
          ++ [
            "result"
            "behavior"
            "formatters"
          ]
        )
      )
      (
        mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "highlight"
            "enabled"
          ]
        )
        (
          settingsPath
          ++ [
            "highlight"
            "enable"
          ]
        )
      )
      (mkRemovedOptionModule (basePluginPath ++ ["jumpToRequest"]) ''
        This option has been deprecated upstream.
      '')
      (mkRemovedOptionModule (basePluginPath ++ ["yankDryRun"]) ''
        This option has been deprecated upstream.
      '')
      (mkRemovedOptionModule (basePluginPath ++ ["searchBack"]) ''
        This option has been deprecated upstream.
      '')
    ];

    settingsOptions = {
      client = helpers.defaultNullOpts.mkStr "curl" ''
        The HTTP client to be used when running requests.
      '';

      env_file = helpers.defaultNullOpts.mkStr ".env" ''
        Environment variables file to be used for the request variables in the document.
      '';

      env_pattern = helpers.defaultNullOpts.mkStr "\\.env$" ''
        Environment variables file pattern for `telescope.nvim`.
      '';

      env_edit_command = helpers.defaultNullOpts.mkStr "tabedit" ''
        Neovim command to edit an environment file.
      '';

      encode_url = helpers.defaultNullOpts.mkBool true ''
        Encode URL before making request.
      '';

      skip_ssl_verification = helpers.defaultNullOpts.mkBool false ''
        Skip SSL verification, useful for unknown certificates.
      '';

      custom_dynamic_variables = mkOption {
        type = with helpers.nixvimTypes; nullOr (maybeRaw (attrsOf strLuaFn));
        default = null;
        example = {
          "$timestamp" = "os.time";
          "$randomInt" = ''
            function()
              return math.random(0, 1000)
            end
          '';
        };
        description = ''
          Custom dynamic variables. Keys are variable names and values are lua functions.

          default: `{}`
        '';
        apply = v:
          if isAttrs v
          then mapAttrs (_: helpers.mkRaw) v
          else v;
      };

      logs = {
        level = helpers.defaultNullOpts.mkNullable helpers.nixvimTypes.logLevel "info" ''
          The logging level name, see `:h vim.log.levels`.
        '';

        save = helpers.defaultNullOpts.mkBool true ''
          Whether to save log messages into a `.log` file.
        '';
      };

      result = {
        split = {
          horizontal = helpers.defaultNullOpts.mkBool false ''
            Open request results in a horizontal split.
          '';

          in_place = helpers.defaultNullOpts.mkBool false ''
            Keep the HTTP file buffer above|left when split horizontal|vertical.
          '';

          stay_in_current_window_after_split = helpers.defaultNullOpts.mkBool true ''
            Stay in the current window (HTTP file) or change the focus to the results window.
          '';
        };

        behavior = {
          show_info = {
            url = helpers.defaultNullOpts.mkBool true ''
              Display the request URL.
            '';

            headers = helpers.defaultNullOpts.mkBool true ''
              Display the request headers.
            '';

            http_info = helpers.defaultNullOpts.mkBool true ''
              Display the request HTTP information.
            '';

            curl_command = helpers.defaultNullOpts.mkBool true ''
              Display the cURL command that was used for the request.
            '';
          };

          decode_url = helpers.defaultNullOpts.mkBool true ''
            Whether to decode the request URL query parameters to improve readability.
          '';

          statistics = {
            enable = helpers.defaultNullOpts.mkBool true ''
              Whether to enable statistics or not.
            '';

            stats = helpers.defaultNullOpts.mkListOf (with types; attrsOf str) ''
              [
                {
                  __unkeyed = "total_time";
                  title = "Time taken:";
                }
                {
                  __unkeyed = "size_download_t";
                  title = "Download size:";
                }
              ]
            '' "See https://curl.se/libcurl/c/curl_easy_getinfo.html.";
          };

          formatters = {
            json = helpers.defaultNullOpts.mkStr "jq" ''
              JSON formatter.
            '';

            html = helpers.defaultNullOpts.mkStr ''
              {
                __raw = \'\'
                  function(body)
                    if vim.fn.executable("tidy") == 0 then
                      return body, { found = false, name = "tidy" }
                    end
                    local fmt_body = vim.fn.system({
                      "tidy",
                      "-i",
                      "-q",
                      "--tidy-mark",      "no",
                      "--show-body-only", "auto",
                      "--show-errors",    "0",
                      "--show-warnings",  "0",
                      "-",
                    }, body):gsub("\n$", "")

                    return fmt_body, { found = true, name = "tidy" }
                  end
                \'\';
              }
            '' "HTML formatter.";
          };
        };

        keybinds = {
          buffer_local = helpers.defaultNullOpts.mkBool false ''
            Enable keybinds only in request result buffer.
          '';

          prev = helpers.defaultNullOpts.mkStr "H" ''
            Mapping for cycle to previous result pane.
          '';

          next = helpers.defaultNullOpts.mkStr "L" ''
            Mapping for cycle to next result pane.
          '';
        };
      };

      highlight = {
        enable = helpers.defaultNullOpts.mkBool true ''
          Whether current request highlighting is enabled or not.
        '';

        timeout = helpers.defaultNullOpts.mkUnsignedInt 750 ''
          Duration time of the request highlighting in milliseconds.
        '';
      };

      keybinds =
        helpers.defaultNullOpts.mkListOf (with types; listOf str)
        ''
          [
            [
              "<localleader>rr"
              "<cmd>Rest run<cr>"
              "Run request under the cursor"
            ]
            [
              "<localleader>rl"
              "<cmd>Rest run last<cr>"
              "Re-run latest request"
            ]
          ]
        ''
        ''
          Declare some keybindings.
          Format: list of 3 strings lists: key, action and description.
        '';
    };

    settingsExample = {
      client = "curl";
      env_file = ".env";
      logs = {
        level = "info";
        save = true;
      };
      result = {
        split = {
          horizontal = false;
          in_place = false;
          stay_in_current_window_after_split = true;
        };
      };
      keybinds = [
        [
          "<localleader>rr"
          "<cmd>Rest run<cr>"
          "Run request under the cursor"
        ]
        [
          "<localleader>rl"
          "<cmd>Rest run last<cr>"
          "Re-run latest request"
        ]
      ];
    };
  }
