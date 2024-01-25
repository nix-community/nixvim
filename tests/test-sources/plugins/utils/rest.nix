{
  empty = {
    plugins.rest.enable = true;
  };

  defaults = {
    plugins.rest = {
      enable = true;

      resultSplitHorizontal = false;
      resultSplitInPlace = false;
      stayInCurrentWindowAfterSplit = false;
      skipSslVerification = false;
      encodeUrl = true;
      highlight = {
        enabled = true;
        timeout = 150;
      };
      result = {
        showUrl = true;
        showCurlCommand = true;
        showHttpInfo = true;
        showHeaders = true;
        showStatistics = false;
        formatters = {
          json = "jq";
          html.__raw = ''
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
          '';
        };
      };
      jumpToRequest = false;
      envFile = ".env";
      customDynamicVariables = null;
      yankDryRun = true;
      searchBack = true;
    };
  };
}
