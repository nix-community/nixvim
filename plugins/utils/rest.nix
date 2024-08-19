{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkRemovedOptionModule mkRenamedOptionModule types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "rest";
  originalName = "rest.nvim";
  luaName = "rest-nvim";
  package = "rest-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

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
  imports =
    let
      basePluginPath = [
        "plugins"
        "rest"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    [
      (mkRenamedOptionModule (basePluginPath ++ [ "resultSplitHorizontal" ]) (
        settingsPath
        ++ [
          "result"
          "split"
          "horizontal"
        ]
      ))
      (mkRenamedOptionModule (basePluginPath ++ [ "resultSplitInPlace" ]) (
        settingsPath
        ++ [
          "result"
          "split"
          "in_place"
        ]
      ))
      (mkRenamedOptionModule (basePluginPath ++ [ "stayInCurrentWindowAfterSplit" ]) (
        settingsPath
        ++ [
          "result"
          "split"
          "stay_in_current_window_after_split"
        ]
      ))
      (mkRenamedOptionModule
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
      (mkRenamedOptionModule
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
      (mkRenamedOptionModule
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
      (mkRenamedOptionModule
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
      (mkRemovedOptionModule
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
      (mkRenamedOptionModule
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
      (mkRenamedOptionModule
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
      (mkRemovedOptionModule (basePluginPath ++ [ "jumpToRequest" ]) ''
        This option has been deprecated upstream.
      '')
      (mkRemovedOptionModule (basePluginPath ++ [ "yankDryRun" ]) ''
        This option has been deprecated upstream.
      '')
      (mkRemovedOptionModule (basePluginPath ++ [ "searchBack" ]) ''
        This option has been deprecated upstream.
      '')
    ];

  settingsOptions = {
    client = defaultNullOpts.mkStr "curl" ''
      The HTTP client to be used when running requests.
    '';

    env_file = defaultNullOpts.mkStr ".env" ''
      Environment variables file to be used for the request variables in the document.
    '';

    env_pattern = defaultNullOpts.mkStr "\\.env$" ''
      Environment variables file pattern for `telescope.nvim`.
    '';

    env_edit_command = defaultNullOpts.mkStr "tabedit" ''
      Neovim command to edit an environment file.
    '';

    encode_url = defaultNullOpts.mkBool true ''
      Encode URL before making request.
    '';

    skip_ssl_verification = defaultNullOpts.mkBool false ''
      Skip SSL verification, useful for unknown certificates.
    '';

    custom_dynamic_variables = lib.mkOption {
      type = with types; nullOr (maybeRaw (attrsOf strLuaFn));
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
      apply = v: if lib.isAttrs v then lib.mapAttrs (_: lib.nixvim.mkRaw) v else v;
    };

    logs = {
      level = defaultNullOpts.mkNullable types.logLevel "info" ''
        The logging level name, see `:h vim.log.levels`.
      '';

      save = defaultNullOpts.mkBool true ''
        Whether to save log messages into a `.log` file.
      '';
    };

    result = {
      split = {
        horizontal = defaultNullOpts.mkBool false ''
          Open request results in a horizontal split.
        '';

        in_place = defaultNullOpts.mkBool false ''
          Keep the HTTP file buffer above|left when split horizontal|vertical.
        '';

        stay_in_current_window_after_split = defaultNullOpts.mkBool true ''
          Stay in the current window (HTTP file) or change the focus to the results window.
        '';
      };

      behavior = {
        show_info = {
          url = defaultNullOpts.mkBool true ''
            Display the request URL.
          '';

          headers = defaultNullOpts.mkBool true ''
            Display the request headers.
          '';

          http_info = defaultNullOpts.mkBool true ''
            Display the request HTTP information.
          '';

          curl_command = defaultNullOpts.mkBool true ''
            Display the cURL command that was used for the request.
          '';
        };

        decode_url = defaultNullOpts.mkBool true ''
          Whether to decode the request URL query parameters to improve readability.
        '';

        statistics = {
          enable = defaultNullOpts.mkBool true ''
            Whether to enable statistics or not.
          '';

          stats = defaultNullOpts.mkListOf (with types; attrsOf str) [
            {
              __unkeyed = "total_time";
              title = "Time taken:";
            }
            {
              __unkeyed = "size_download_t";
              title = "Download size:";
            }
          ] "See https://curl.se/libcurl/c/curl_easy_getinfo.html.";
        };

        formatters = {
          json = defaultNullOpts.mkStr "jq" ''
            JSON formatter.
          '';

          html = defaultNullOpts.mkStr {
            __raw = ''
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
            '';
          } "HTML formatter.";
        };
      };

      keybinds = {
        buffer_local = defaultNullOpts.mkBool false ''
          Enable keybinds only in request result buffer.
        '';

        prev = defaultNullOpts.mkStr "H" ''
          Mapping for cycle to previous result pane.
        '';

        next = defaultNullOpts.mkStr "L" ''
          Mapping for cycle to next result pane.
        '';
      };
    };

    highlight = {
      enable = defaultNullOpts.mkBool true ''
        Whether current request highlighting is enabled or not.
      '';

      timeout = defaultNullOpts.mkUnsignedInt 750 ''
        Duration time of the request highlighting in milliseconds.
      '';
    };

    keybinds =
      defaultNullOpts.mkListOf (with types; listOf str)
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

  extraOptions = {
    curlPackage = lib.mkPackageOption pkgs "curl" {
      nullable = true;
    };

    enableHttpFiletypeAssociation = lib.mkOption {
      type = types.bool;
      default = true;
      description = ''
        Sets up the filetype association of `.http` files to trigger treesitter support to enable `rest` functionality.
      '';
    };

    enableTelescope = lib.mkEnableOption "telescope integration";
  };

  extraConfig = cfg: {
    assertions = [
      {
        assertion = config.plugins.treesitter.enable;
        message = ''
          Nixvim (plugins.rest): Requires the `http` parser from `plugins.treesitter`, please set `plugins.treesitter.enable`.
        '';
      }
      {
        assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
        message = ''
          Nixvim (plugins.rest): You have `plugins.rest.enableTelescope` set to true, but `plugins.telescope.enable` is false.
          Either disable the telescope integration or enable telescope.
        '';
      }
    ];

    # TODO: There may be some interactions between this & telescope, maybe requiring #2292
    plugins.rest.luaConfig.post = lib.mkIf cfg.enableTelescope ''require("telescope").load_extension("rest")'';

    extraPackages = [ cfg.curlPackage ];

    filetype = lib.mkIf cfg.enableHttpFiletypeAssociation {
      extension.http = "http";
    };
  };
}
