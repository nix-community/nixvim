{
  lib,
  pkgs,
  config,
  ...
}: let
  helpers = import ../helpers.nix {inherit lib;};
in
  with lib; let
    borderOpt = let
      bordersTy =
        types.enum ["double" "rounded" "single" "shadow" "none"];
    in
      helpers.defaultNullOpts.mkNullable (types.either bordersTy (types.listOf bordersTy))
      ''"none"'' "";
  in {
    options.plugins.clangd-extensions = {
      enable = mkEnableOption "clangd_extensions, plugin implementing clangd LSP extensions";

      package =
        helpers.mkPackageOption "clangd_extensions.nvim" pkgs.vimPlugins.clangd_extensions-nvim;

      enableOffsetEncodingWorkaround = mkEnableOption ''
        utf-16 offset encoding. This is used to work around the warning:
        "multiple different client offset_encodings detected for buffer, this is not supported yet"
      '';

      server = {
        package = mkOption {
          type = types.package;
          default = pkgs.clang-tools;
          description = "Package to use for clangd";
        };

        extraOptions = mkOption {
          type = types.attrsOf types.anything;
          default = {};
          description = "Extra options to pass to nvim-lspconfig. You should not need to use this directly";
        };
      };

      extensions = {
        autoSetHints = helpers.defaultNullOpts.mkBool true "Automatically set inlay hints (type hints)";
        inlayHints = {
          onlyCurrentLine =
            helpers.defaultNullOpts.mkBool false
            "Only show inlay hints for the current line";
          onlyCurrentLineAutocmd = helpers.defaultNullOpts.mkStr "CursorHold" ''
            Event which triggers a refersh of the inlay hints.
            You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            not that this may cause  higher CPU usage.
            This option is only respected when only_current_line and
            autoSetHints both are true.
          '';
          showParameterHints =
            helpers.defaultNullOpts.mkBool true
            "whether to show parameter hints with the inlay hints or not";
          parameterHintsPrefix = helpers.defaultNullOpts.mkStr "<- " "prefix for parameter hints";
          otherHintsPrefix =
            helpers.defaultNullOpts.mkStr "=> "
            "prefix for all the other hints (type, chaining)";
          maxLenAlign =
            helpers.defaultNullOpts.mkBool false
            "whether to align to the length of the longest line in the file";
          maxLenAlignPadding =
            helpers.defaultNullOpts.mkInt 1
            "padding from the left if max_len_align is true";
          rightAlign =
            helpers.defaultNullOpts.mkBool false
            "whether to align to the extreme right or not";
          rightAlignPadding =
            helpers.defaultNullOpts.mkInt 7
            "padding from the right if right_align is true";
          highlight =
            helpers.defaultNullOpts.mkStr "Comment"
            "The color of the hints";
          priority = helpers.defaultNullOpts.mkInt 100 "The highlight group priority for extmark";
        };

        ast = {
          roleIcons = {
            type = helpers.defaultNullOpts.mkStr "🄣" "";
            declaration = helpers.defaultNullOpts.mkStr "🄓" "";
            expression = helpers.defaultNullOpts.mkStr "🄔" "";
            statement = helpers.defaultNullOpts.mkStr ";" "";
            specifier = helpers.defaultNullOpts.mkStr "🄢" "";
            templateArgument = helpers.defaultNullOpts.mkStr "🆃" "";
          };

          kindIcons = {
            compound = helpers.defaultNullOpts.mkStr "🄲" "";
            recovery = helpers.defaultNullOpts.mkStr "🅁" "";
            translationUnit = helpers.defaultNullOpts.mkStr "🅄" "";
            packExpansion = helpers.defaultNullOpts.mkStr "🄿" "";
            templateTypeParm = helpers.defaultNullOpts.mkStr "🅃" "";
            templateTemplateParm = helpers.defaultNullOpts.mkStr "🅃" "";
            templateParamObject = helpers.defaultNullOpts.mkStr "🅃" "";
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
    };

    config = let
      cfg = config.plugins.clangd-extensions;
      setupOptions = {
        server = cfg.server.extraOptions;
        extensions = {
          inherit (cfg.extensions) autoSetHints;
          inlay_hints = {
            only_current_line = cfg.extensions.inlayHints.onlyCurrentLine;
            only_current_line_autocmd = cfg.extensions.inlayHints.onlyCurrentLineAutocmd;
            show_parameter_hints = cfg.extensions.inlayHints.showParameterHints;
            parameter_hints_prefix = cfg.extensions.inlayHints.parameterHintsPrefix;
            other_hints_prefix = cfg.extensions.inlayHints.otherHintsPrefix;
            max_len_align = cfg.extensions.inlayHints.maxLenAlign;
            max_len_align_padding = cfg.extensions.inlayHints.maxLenAlignPadding;
            right_align = cfg.extensions.inlayHints.rightAlign;
            right_align_padding = cfg.extensions.inlayHints.rightAlignPadding;
            inherit (cfg.extensions.inlayHints) highlight priority;
          };
          ast = {
            role_icons = {
              inherit (cfg.extensions.ast.roleIcons) type declaration expression statement specifier;
              "template argument" = cfg.extensions.ast.roleIcons.templateArgument;
            };
            kind_icons = {
              Compound = cfg.extensions.ast.kindIcons.compound;
              Recovery = cfg.extensions.ast.kindIcons.recovery;
              TranslationUnit = cfg.extensions.ast.kindIcons.translationUnit;
              PackExpansion = cfg.extensions.ast.kindIcons.packExpansion;
              TemplateTypeParm = cfg.extensions.ast.kindIcons.templateTypeParm;
              TemplateTemplateParm = cfg.extensions.ast.kindIcons.templateTemplateParm;
              TemplateParamObject = cfg.extensions.ast.kindIcons.templateParamObject;
            };
            highlights = {
              inherit (cfg.extensions.ast.highlights) detail;
            };
          };
          memory_usage = {
            inherit (cfg.extensions.memoryUsage) border;
          };
          symbol_info = {
            inherit (cfg.extensions.symbolInfo) border;
          };
        };
      };
    in
      mkIf cfg.enable {
        extraPackages = [cfg.server.package];
        extraPlugins = [cfg.package];

        plugins.clangd-extensions.server.extraOptions = mkIf cfg.enableOffsetEncodingWorkaround {
          capabilities = {__raw = "__clangdCaps";};
        };

        plugins.lsp.postConfig = let
          extraCaps =
            if cfg.enableOffsetEncodingWorkaround
            then ''
              local __clangdCaps = vim.lsp.protocol.make_client_capabilities()
              __clangdCaps.offsetEncoding = { "utf-16" }
            ''
            else "";
        in ''
          ${extraCaps}
          require("clangd_extensions").setup(${helpers.toLuaObject setupOptions})
        '';
      };
  }
