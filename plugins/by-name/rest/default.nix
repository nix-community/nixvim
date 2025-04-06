{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkRemovedOptionModule types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "rest";
  packPathName = "rest.nvim";
  moduleName = "rest-nvim";
  package = "rest-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-04-07: remove 2024-06-07
  deprecateExtraOptions = true;
  optionsRenamedToSettings = import ./renamed-options.nix;
  imports =
    let
      basePluginPath = [
        "plugins"
        "rest"
      ];
    in
    [
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

      # TODO: added 2025-04-06: remove after 25.05
      (lib.nixvim.mkRemovedPackageOptionModule {
        plugin = "rest";
        packageName = "curl";
      })
    ]
    ++
      map
        (
          option:
          mkRemovedOptionModule (basePluginPath ++ [ option ]) ''
            This option has been deprecated upstream.
          ''
        )
        [
          "jumpToRequest"
          "yankDryRun"
          "searchBack"
        ];

  settingsOptions = {
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
    };

    request = {
      skip_ssl_verification = defaultNullOpts.mkBool false ''
        Skip SSL verification, useful for unknown certificates.
      '';

      hooks = {
        encode_url = defaultNullOpts.mkBool true ''
          Encode URL before making request.
        '';

        user_agent = defaultNullOpts.mkStr (lib.nixvim.mkRaw ''"rest.nvim v" .. require("rest-nvim.api").VERSION'') ''
          Set `User-Agent` header when it is empty.
        '';

        set_content_type = defaultNullOpts.mkBool true ''
          Set `Content-Type` header when it is empty and body is provided.
        '';
      };
    };

    response = {
      hooks = {
        decode_url = defaultNullOpts.mkBool true ''
          Encode URL before making request.
        '';

        format = defaultNullOpts.mkBool true ''
          Format the response body using `gq` command.
        '';
      };

    };

    clients = defaultNullOpts.mkAttrsOf types.anything {
      curl = {
        statistics = [
          {
            id = "time_total";
            winbar = "take";
            title = "Time taken";
          }
          {
            id = "size_download";
            winbar = "size";
            title = "Download size";
          }
        ];
        opts = {
          set_compressed = false;
        };
      };
    } ''Table of client configurations.'';

    cookies = {
      enable = defaultNullOpts.mkBool true ''
        Whether to enable cookies support or not.
      '';

      path = defaultNullOpts.mkStr (lib.nixvim.mkRaw ''vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "rest-nvim.cookies")'') ''
        Environment variables file pattern for `telescope.nvim`.
      '';
    };

    env = {
      enable = defaultNullOpts.mkBool true ''
        Whether to enable env file support or not.
      '';

      pattern = defaultNullOpts.mkStr "\\.env$" ''
        Environment variables file pattern for `telescope.nvim`.
      '';
    };

    ui = {
      winbar = defaultNullOpts.mkBool true ''
        Whether to set winbar to result panes.
      '';

      keybinds =
        defaultNullOpts.mkAttrsOf types.anything
          {
            prev = "H";
            next = "L";
          }
          ''
            Mappings for result panes.
          '';
    };

    highlight = {
      enable = defaultNullOpts.mkBool true ''
        Whether current request highlighting is enabled or not.
      '';

      timeout = defaultNullOpts.mkUnsignedInt 750 ''
        Duration time of the request highlighting in milliseconds.
      '';
    };

    _log_level = defaultNullOpts.mkNullableWithRaw types.logLevel "warn" ''
      The logging level name, see `:h vim.log.levels`.
    '';
  };

  settingsExample = {
    request = {
      skip_ssl_verification = true;
    };
    response = {
      hooks = {
        format = false;
      };
    };
    clients = {
      curl = {
        opts = {
          set_compressed = true;
        };
      };
    };
    cookies = {
      enable = false;
    };
    env = {
      enable = false;
    };
    ui = {
      winbar = false;
    };
    _log_level = "info";
  };

  extraOptions = {
    enableHttpFiletypeAssociation = lib.mkOption {
      type = types.bool;
      default = true;
      description = ''
        Sets up the filetype association of `.http` files to trigger treesitter support to enable `rest` functionality.
      '';
    };

    enableTelescope = lib.mkEnableOption "telescope integration";
  };

  # NOTE: plugin uses globals table for configuration
  callSetup = false;

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.rest" [
      {
        assertion = config.plugins.treesitter.enable;
        message = ''
          Requires the `http` parser from `plugins.treesitter`, please set `plugins.treesitter.enable`.
        '';
      }
      {
        assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
        message = ''
          You have `plugins.rest.enableTelescope` set to true, but `plugins.telescope.enable` is false.
          Either disable the telescope integration or enable telescope.
        '';
      }
    ];

    # TODO: introduced 2024-09-23: remove after 24.11
    warnings =
      let
        definedOpts = lib.filter (opt: lib.hasAttrByPath (lib.toList opt) cfg.settings) [
          "client"
          "env_file"
          "env_pattern"
          "env_edit_command"
          "encode_url"
          "keybinds"
          "skip_ssl_verification"
          [
            "logs"
            "level"
          ]
          [
            "logs"
            "save"
          ]
          [
            "result"
            "split"
          ]
          [
            "result"
            "behavior"
          ]
          [
            "result"
            "statistics"
          ]
          [
            "result"
            "decode_url"
          ]
          [
            "result"
            "formatters"
          ]
          [
            "result"
            "keybinds"
          ]
        ];
      in
      lib.nixvim.mkWarnings "plugins.rest" {
        when = definedOpts != [ ];
        message = ''
          The following v2 settings options are no longer supported in v3:
          ${lib.concatMapStringsSep "\n" (opt: "  - ${lib.showOption (lib.toList opt)}") definedOpts}
        '';
      };

    # TODO: There may be some interactions between this & telescope, maybe requiring #2292
    plugins.rest.luaConfig.post = lib.mkIf cfg.enableTelescope ''require("telescope").load_extension("rest")'';

    globals.rest_nvim = cfg.settings;

    dependencies.curl.enable = lib.mkDefault true;

    filetype = lib.mkIf cfg.enableHttpFiletypeAssociation {
      extension.http = "http";
    };
  };
}
