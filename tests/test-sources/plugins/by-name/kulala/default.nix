{
  empty = {
    # The plugin tries to install a treesitter grammar at startup
    # https://github.com/mistweaverco/kulala.nvim/blob/9d3206dda077d24ef3e6a2e3578bc0c914b4944c/lua/kulala/config/init.lua#L75
    test.runNvim = false;

    plugins.kulala.enable = true;
  };

  default = {
    # The plugin tries to install a treesitter grammar at startup
    # https://github.com/mistweaverco/kulala.nvim/blob/9d3206dda077d24ef3e6a2e3578bc0c914b4944c/lua/kulala/config/init.lua#L75
    test.runNvim = false;

    plugins.kulala = {
      enable = true;

      settings = {
        curl_path = "curl";
        display_mode = "split";
        split_direction = "vertical";
        default_view = "body";
        default_env = "dev";
        debug = false;
        contenttypes = {
          "application/json" = {
            ft = "json";
            formatter = [
              "jq"
              "."
            ];
            pathresolver = "kulala.parser.jsonpath.parse";
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
        };
        show_icons = "on_request";
        icons = {
          inlay = {
            loading = "⏳";
            done = "✅";
            error = "❌";
          };
          lualine = "🐼";
        };
        additional_curl_options = { };
        scratchpad_default_contents = [
          "@MY_TOKEN_NAME=my_token_value"
          ""
          "# @name scratchpad"
          "POST https://httpbin.org/post HTTP/1.1"
          "accept: application/json"
          "content-type: application/json"
          ""
        ];
        winbar = false;
        default_winbar_panes = [
          "body"
          "headers"
          "headers_body"
        ];
        vscode_rest_client_environmentvars = false;
        disable_script_print_output = false;
        environment_scope = "b";
        certificates = { };
      };
    };
  };
}
