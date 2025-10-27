{
  empty = {
    plugins.gitlab.enable = true;
  };

  defaults = {
    plugins.gitlab = {
      enable = true;

      settings = {
        gitlab_url = "https://gitlab.com";
        statuslines = {
          enable = true;
        };
        resource_editing = {
          enable = false;
        };
        minimal_message_level = 0;
        code_suggestions = {
          auto_filetypes = [
            "c"
            "cpp"
            "csharp"
            "go"
            "java"
            "javascript"
            "javascriptreact"
            "kotlin"
            "markdown"
            "objective-c"
            "objective-cpp"
            "php"
            "python"
            "ruby"
            "rust"
            "scala"
            "sql"
            "swift"
            "terraform"
            "typescript"
            "typescriptreact"
            "sh"
            "html"
            "css"
          ];
          enabled = true;
          fix_newlines = true;
          lsp_binary_path = "node";
          offset_encoding = "utf-16";
          redact_secrets = true;
        };
        language_server = {
          workspace_settings = {
            codeCompletion = {
              enableSecretRedaction = true;
            };
            telemetry = {
              enabled = true;
              trackingUrl.__raw = "nil";
            };
          };
        };
      };
    };
  };

  example = {
    plugins.gitlab = {
      enable = true;

      settings = {
        code_suggestions = {
          auto_filetypes = [ "ruby" ];
        };
      };
    };
  };
}
