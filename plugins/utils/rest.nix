{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.rest;
in {
  meta.maintainers = [maintainers.GaetanLepage];

  options.plugins.rest =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "rest.nvim";

      package = helpers.mkPackageOption "rest.nvim" pkgs.vimPlugins.rest-nvim;

      resultSplitHorizontal = helpers.defaultNullOpts.mkBool false ''
        Open request results in a horizontal split (default opens on vertical).
      '';

      resultSplitInPlace = helpers.defaultNullOpts.mkBool false ''
        Keep the http file buffer above|left when split horizontal|vertical.
      '';

      stayInCurrentWindowAfterSplit = helpers.defaultNullOpts.mkBool false ''
        Stay in current windows (`.http` file) or change to results window (default).
      '';

      skipSslVerification = helpers.defaultNullOpts.mkBool false ''
        Skip SSL verification, useful for unknown certificates.
      '';

      encodeUrl = helpers.defaultNullOpts.mkBool true ''
        Encode URL before making request.
      '';

      highlight = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enable the highlighting of the selected request when send.
        '';

        timeout = helpers.defaultNullOpts.mkUnsignedInt 150 ''
          Timeout for highlighting.
        '';
      };

      result = {
        showUrl = helpers.defaultNullOpts.mkBool true ''
          Toggle showing URL, HTTP info, headers at top the of result window.
        '';

        showCurlCommand = helpers.defaultNullOpts.mkBool true ''
          Show the generated curl command in case you want to launch the same request via the
          terminal (can be verbose).
        '';

        showHttpInfo = helpers.defaultNullOpts.mkBool true ''
          Show HTTP information.
        '';

        showHeaders = helpers.defaultNullOpts.mkBool true ''
          Show headers information.
        '';

        showStatistics =
          helpers.defaultNullOpts.mkNullable
          (
            with types;
              either
              (enum [false])
              (
                listOf
                (
                  either
                  str
                  (listOf str)
                )
              )
          )
          "false"
          ''
            Table of curl `--write-out` variables or false if disabled.
            For more granular control see [Statistics Spec](https://github.com/rest-nvim/rest.nvim?tab=readme-ov-file#statistics-spec).
          '';

        formatters =
          helpers.defaultNullOpts.mkAttrsOf
          (
            with types;
              either str (enum [false])
          )
          ''
            {
              json = "jq";
              html.__raw = \'\'
                function(body)
                  if vim.fn.executable("tidy") == 0 then
                    return body
                  end
                  -- stylua: ignore
                  return vim.fn.system({
                    "tidy", "-i", "-q",
                    "--tidy-mark",      "no",
                    "--show-body-only", "auto",
                    "--show-errors",    "0",
                    "--show-warnings",  "0",
                    "-",
                  }, body):gsub("\n$", "")
                end
              \'\';
            }
          ''
          ''
            Executables or functions for formatting response body [optional].
            Set them to false if you want to disable them.
          '';
      };

      jumpToRequest = helpers.defaultNullOpts.mkBool false ''
        Moves the cursor to the selected request line when send.
      '';

      envFile = helpers.defaultNullOpts.mkStr ".env" ''
        Specifies file name that consist environment variables.
      '';

      customDynamicVariables = mkOption {
        type = with helpers.nixvimTypes; nullOr (attrsOf strLuaFn);
        default = null;
        description = ''
          Allows to extend or overwrite built-in dynamic variable functions.
        '';
        apply = v: helpers.ifNonNull' v (mapAttrs (_: helpers.mkRaw) v);
      };

      yankDryRun = helpers.defaultNullOpts.mkBool true "";

      searchBack = helpers.defaultNullOpts.mkBool true "";
    };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    extraPackages = [pkgs.curl];

    extraConfigLua = let
      setupOptions = with cfg;
        {
          result_split_horizontal = resultSplitHorizontal;
          result_split_in_place = resultSplitInPlace;
          stay_in_current_window_after_split = stayInCurrentWindowAfterSplit;
          skip_ssl_verification = skipSslVerification;
          encode_url = encodeUrl;
          highlight = with highlight; {
            inherit
              (highlight)
              enabled
              timeout
              ;
          };
          result = with result; {
            show_url = showUrl;
            show_curl_command = showCurlCommand;
            show_http_info = showHttpInfo;
            show_headers = showHeaders;
            show_statistics = showStatistics;
            inherit formatters;
          };
          jump_to_request = jumpToRequest;
          env_file = envFile;
          custom_dynamic_variables = customDynamicVariables;
          yank_dry_run = yankDryRun;
          search_back = searchBack;
        }
        // cfg.extraOptions;
    in ''
      require('rest-nvim').setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
