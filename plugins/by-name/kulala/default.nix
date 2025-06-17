{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "kulala";
  packPathName = "kulala.nvim";
  package = "kulala-nvim";
  description = "A fully-featured REST Client Interface for Neovim.";

  maintainers = [ lib.maintainers.BoneyPatel ];

  settingsOptions = {
    curl_path = defaultNullOpts.mkStr "curl" ''
      Path to the cURL binary. Set this if cURL is installed in a non-standard location.
    '';

    display_mode =
      defaultNullOpts.mkEnumFirstDefault
        [
          "split"
          "float"
        ]
        ''
          Defines how the request/response is displayed. Options are "split" or "float".
        '';

    split_direction =
      defaultNullOpts.mkEnumFirstDefault
        [
          "vertical"
          "horizontal"
        ]
        ''
          Defines the direction of the split window. Options are "vertical" or "horizontal".
        '';

    default_view =
      defaultNullOpts.mkEnumFirstDefault
        [
          "body"
          "headers"
          "headers_body"
        ]
        ''
          Sets the default view mode for responses. Options are "body", "headers", or "headers_body".
        '';

    default_env = defaultNullOpts.mkStr "dev" ''
      Sets the default environment for requests. Common options are "dev", "test", or "prod".
    '';

    debug = defaultNullOpts.mkBool false ''
      Enables or disables debug mode.
    '';

    contenttypes =
      defaultNullOpts.mkAttrsOf types.anything
        {
          "application/json" = {
            ft = "json";
            formatter = [
              "jq"
              "."
            ];
            pathresolver.__raw = "require('kulala.parser.jsonpath').parse";
          };
          "application/xml" = {
            ft = "xml";
            formatter = [
              "xmllint"
              "--format"
              "-"
            ];
            pathresolver = [
              "xmllint"
              "--xpath"
              "{{path}}"
              "-"
            ];
          };
          "text/html" = {
            ft = "html";
            formatter = [
              "xmllint"
              "--format"
              "--html"
              "-"
            ];
            pathresolver = [ ];
          };
        }
        ''
          Defines formatters and path resolvers for specific content types.
        '';

    show_icons =
      defaultNullOpts.mkEnumFirstDefault
        [
          "on_request"
          "above_request"
          "below_request"
        ]
        ''
          Determines where icons are displayed relative to requests. Options are `"on_request"`, `"above_request"`, `"below_request"`, or `{__raw = "nil";}` to disable.
        '';

    icons =
      defaultNullOpts.mkAttrsOf types.anything
        {
          inlay = {
            loading = "⏳";
            done = "✅";
            error = "❌";
          };
          lualine = "🐼";
        }
        ''
          Sets default icons for loading states and lualine.
        '';

    scratchpad_default_contents =
      defaultNullOpts.mkListOf types.anything
        [
          "@MY_TOKEN_NAME=my_token_value"
          ""
          "# @name scratchpad"
          "POST https://httpbin.org/post HTTP/1.1"
          "accept: application/json"
          "content-type: application/json"
        ]
        ''
          Default contents for the scratchpad feature.
        '';

    winbar = defaultNullOpts.mkBool false ''
      Enables or disables the winbar for displaying request status.
    '';

    default_winbar_panes =
      defaultNullOpts.mkListOf types.str
        [
          "body"
          "headers"
          "headers_body"
        ]
        ''
          Specifies which panes are displayed by default in the winbar.
        '';

    vscode_rest_client_environmentvars = defaultNullOpts.mkBool false ''
      Enables reading environment variables from VSCode’s REST client.
    '';

    disable_script_print_output = defaultNullOpts.mkBool false ''
      Disables immediate printing of script outputs; outputs will still be written to disk.
    '';

    environment_scope =
      defaultNullOpts.mkEnumFirstDefault
        [
          "b"
          "g"
        ]
        ''
          Sets the scope for environment and request variables. Options are "b" (buffer) or "g" (global).
        '';

    certificates = defaultNullOpts.mkAttrsOf types.anything { } ''
      Configures SSL/TLS certificates.
    '';
  };

  settingsExample = {
    default_view = "body";
    default_env = "dev";
    debug = false;
    icons = {
      inlay = {
        loading = "⏳";
        done = "✅";
        error = "❌";
      };
      lualine = "🐼";
    };
    additional_curl_options = { };
    environment_scope = "b";
  };

}
