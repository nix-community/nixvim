{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.clangd-extensions;

  basePluginPath = [
    "plugins"
    "clangd-extensions"
  ];

  borderOpt = helpers.defaultNullOpts.mkBorder "none" "clangd-extensions" "";
in
{
  # All of those warnings were introduced on 08/22/2023.
  # TODO: Remove them in ~2 months (Oct. 2023).
  imports =
    [
      (mkRemovedOptionModule (basePluginPath ++ [ "server" ]) ''
        To configure the `clangd` language server options, please use
        `plugins.lsp.servers.clangd.extraSettings`.
      '')
      (mkRemovedOptionModule (
        basePluginPath
        ++ [
          "extensions"
          "autoSetHints"
        ]
      ) "")
    ]
    ++ (map
      (
        optionPath:
        mkRenamedOptionModule (basePluginPath ++ [ "extensions" ] ++ optionPath) (
          basePluginPath ++ optionPath
        )
      )
      [
        [
          "inlayHints"
          "inline"
        ]
        [
          "inlayHints"
          "onlyCurrentLine"
        ]
        [
          "inlayHints"
          "onlyCurrentLineAutocmd"
        ]
        [
          "inlayHints"
          "showParameterHints"
        ]
        [
          "inlayHints"
          "parameterHintsPrefix"
        ]
        [
          "inlayHints"
          "otherHintsPrefix"
        ]
        [
          "inlayHints"
          "maxLenAlign"
        ]
        [
          "inlayHints"
          "maxLenAlignPadding"
        ]
        [
          "inlayHints"
          "rightAlign"
        ]
        [
          "inlayHints"
          "rightAlignPadding"
        ]
        [
          "inlayHints"
          "highlight"
        ]
        [
          "inlayHints"
          "priority"
        ]
        [ "ast" ]
        [ "memoryUsage" ]
        [ "symbolInfo" ]
      ]
    );

  options.plugins.clangd-extensions = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "clangd_extensions, plugins implementing clangd LSP extensions";

    package = lib.mkPackageOption pkgs "clangd_extensions.nvim" {
      default = [
        "vimPlugins"
        "clangd_extensions-nvim"
      ];
    };

    enableOffsetEncodingWorkaround = mkEnableOption ''
      utf-16 offset encoding. This is used to work around the warning:
      "multiple different client offset_encodings detected for buffer, this is not supported yet"
    '';

    inlayHints = {
      inline = helpers.defaultNullOpts.mkLua ''vim.fn.has("nvim-0.10") == 1'' ''
        Show hints inline.
      '';

      onlyCurrentLine = helpers.defaultNullOpts.mkBool false "Only show inlay hints for the current line";

      onlyCurrentLineAutocmd = helpers.defaultNullOpts.mkStr "CursorHold" ''
        Event which triggers a refersh of the inlay hints.
        You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
        not that this may cause  higher CPU usage.
        This option is only respected when `onlyCurrentLine` is true.
      '';

      showParameterHints = helpers.defaultNullOpts.mkBool true ''
        Whether to show parameter hints with the inlay hints or not.
      '';

      parameterHintsPrefix = helpers.defaultNullOpts.mkStr "<- " "Prefix for parameter hints.";

      otherHintsPrefix = helpers.defaultNullOpts.mkStr "=> " "Prefix for all the other hints (type, chaining).";

      maxLenAlign = helpers.defaultNullOpts.mkBool false ''
        Whether to align to the length of the longest line in the file.
      '';

      maxLenAlignPadding = helpers.defaultNullOpts.mkInt 1 ''
        Padding from the left if max_len_align is true.
      '';

      rightAlign = helpers.defaultNullOpts.mkBool false ''
        Whether to align to the extreme right or not.
      '';

      rightAlignPadding = helpers.defaultNullOpts.mkInt 7 ''
        Padding from the right if right_align is true.
      '';

      highlight = helpers.defaultNullOpts.mkStr "Comment" "The color of the hints.";

      priority = helpers.defaultNullOpts.mkInt 100 "The highlight group priority for extmark.";
    };

    ast = {
      roleIcons = mapAttrs (name: default: helpers.defaultNullOpts.mkStr default "") {
        type = "🄣";
        declaration = "🄓";
        expression = "🄔";
        statement = ";";
        specifier = "🄢";
        templateArgument = "🆃";
      };

      kindIcons = mapAttrs (name: default: helpers.defaultNullOpts.mkStr default "") {
        compound = "🄲";
        recovery = "🅁";
        translationUnit = "🅄";
        packExpansion = "🄿";
        templateTypeParm = "🅃";
        templateTemplateParm = "🅃";
        templateParamObject = "🅃";
      };

      highlights = {
        detail = helpers.defaultNullOpts.mkStr "Comment" "";
      };
    };

    memoryUsage = {
      border = borderOpt;
    };

    symbolInfo = {
      border = borderOpt;
    };
  };

  config =
    let
      setupOptions =
        with cfg;
        {
          inlay_hints = with inlayHints; {
            inherit inline;
            only_current_line = onlyCurrentLine;
            only_current_line_autocmd = onlyCurrentLineAutocmd;
            show_parameter_hints = showParameterHints;
            parameter_hints_prefix = parameterHintsPrefix;
            other_hints_prefix = otherHintsPrefix;
            max_len_align = maxLenAlign;
            max_len_align_padding = maxLenAlignPadding;
            right_align = rightAlign;
            right_align_padding = rightAlignPadding;
            inherit highlight priority;
          };
          ast = with ast; {
            role_icons = with roleIcons; {
              inherit
                type
                declaration
                expression
                statement
                specifier
                ;
              "template argument" = templateArgument;
            };
            kind_icons = with kindIcons; {
              Compound = compound;
              Recovery = recovery;
              TranslationUnit = translationUnit;
              PackExpansion = packExpansion;
              TemplateTypeParm = templateTypeParm;
              TemplateTemplateParm = templateTemplateParm;
              TemplateParamObject = templateParamObject;
            };
            highlights = with highlights; {
              inherit detail;
            };
          };
          memory_usage = with memoryUsage; {
            inherit border;
          };
          symbol_info = with symbolInfo; {
            inherit border;
          };
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      warnings = optional (!config.plugins.lsp.enable) ''
        You have enabled `clangd-extensions` but not the lsp (`plugins.lsp`).
        You should set `plugins.lsp.enable = true` to make use of the clangd-extensions' features.
      '';

      plugins.lsp = {
        servers.clangd = {
          # Enable the clangd language server
          enable = true;

          extraOptions = mkIf cfg.enableOffsetEncodingWorkaround {
            capabilities = {
              __raw = "__clangdCaps";
            };
          };
        };

        preConfig = optionalString cfg.enableOffsetEncodingWorkaround ''
          local __clangdCaps = vim.lsp.protocol.make_client_capabilities()
          __clangdCaps.offsetEncoding = { "utf-16" }
        '';
      };

      extraPlugins = [ cfg.package ];

      plugins.lsp.postConfig = ''
        require("clangd_extensions").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
