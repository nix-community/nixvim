{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gitlab";
  packPathName = "gitlab.vim";
  package = "gitlab-vim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "nodejs" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "gitlab";
      packageName = "nodejs";
      oldPackageName = "node";
    })
  ];

  settingsOptions = {
    gitlab_url = defaultNullOpts.mkStr "https://gitlab.com" ''
      The GitLab instance url to use if not `https://gitlab.com`.
    '';

    statuslines = {
      enable = defaultNullOpts.mkBool true ''
        Whether to enable statuslines.
      '';
    };

    resource_editing = {
      enable = defaultNullOpts.mkBool false ''
        Whether to enable resource editing.
      '';
    };

    minimal_message_level = defaultNullOpts.mkUnsignedInt 0 ''
      Minimal message level for logs.
    '';

    code_suggestions = {
      auto_filetypes =
        defaultNullOpts.mkListOf types.str
          [
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
          ]
          ''
            Filetypes to automatically invoke `|gitlab.code_suggestions.start()|`.
          '';

      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `|gitlab-code-suggestions|` via the LSP binary.
      '';

      fix_newlines = defaultNullOpts.mkBool true ''
        Whether to replace newlines that have become null-byte due to switching between encodings.
      '';

      lsp_binary_path = defaultNullOpts.mkStr' {
        pluginDefault = "node";
        example = lib.literalExpression "lib.getExe pkgs.nodejs";
        description = ''
          The path where the `node` executable is available.

          By default, this option is set to `"node"` which will look for nodejs in your `$PATH`.
          To ensure that `node` will always be in your `$PATH`, you may set the `nodePackage` option.

          Alternatively, you can set this option to `lib.getExe pkgs.nodejs` (or any other package).
        '';
      };

      offset_encoding = defaultNullOpts.mkStr "utf-16" ''
        Which offset encoding to use.
      '';

      redact_secrets = defaultNullOpts.mkBool true ''
        Whether to redact secrets.
      '';
    };

    language_server = {
      workspace_settings = {
        codeCompletion = {
          enableSecretRedaction = defaultNullOpts.mkBool true ''
            Whether to enable secret redactions in completion.
          '';
        };
        telemetry = {
          enabled = defaultNullOpts.mkBool true ''
            Whether to enable telemetry.
          '';

          trackingUrl = defaultNullOpts.mkStr null ''
            URL of the telemetry service.
          '';
        };
      };
    };
  };

  settingsExample = {
    code_suggestions = {
      auto_filetypes = [ "ruby" ];
    };
  };
}
