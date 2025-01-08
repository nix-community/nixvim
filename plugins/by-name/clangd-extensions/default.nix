{ config, lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types mapAttrs;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "clangd-extensions";
  moduleName = "clangd_extensions";
  packPathName = "clangd_extensions.nvim";
  package = "clangd_extensions-nvim";
  description = ''
    Clangd's off-spec features for neovim's LSP client.
  '';

  maintainers = [ lib.maintainers.jolars ];

  # All of those warnings were introduced on 08/22/2023.
  # TODO: Remove them in ~2 months (Oct. 2023).
  imports = [ ./deprecations.nix ];

  # TODO: introduced 2025-01-08: remove after 25.05
  optionsRenamedToSettings = import ./renamed-options.nix;

  settingsOptions =
    let
      mkBorderOpt = defaultNullOpts.mkBorder "none" "clangd-extensions";
    in
    {
      inlay_hints = {
        inline = defaultNullOpts.mkBool true ''
          Show hints inline.
        '';

        only_current_line = defaultNullOpts.mkBool false ''
          Only show inlay hints for the current line.
        '';

        only_current_line_autocmd = defaultNullOpts.mkListOf types.str [ "CursorHold" ] ''
          Event which triggers a refresh of the inlay hints. You can make this
          `[ "CursorMoved" ]` or `[ "CursorMoved" "CursorMovedI" ]` but not that this may cause
          higher CPU usage. This option is only respected when `only_current_line`
          is true.
        '';

        show_parameter_hints = defaultNullOpts.mkBool true ''
          Whether to show parameter hints with the inlay hints or not.
        '';

        parameter_hints_prefix = defaultNullOpts.mkStr "<- " "Prefix for parameter hints.";

        other_hints_prefix = defaultNullOpts.mkStr "=> " ''
          Prefix for all the other hints (type, chaining).
        '';

        max_len_align = defaultNullOpts.mkBool false ''
          Whether to align to the length of the longest line in the file.
        '';

        max_len_align_padding = defaultNullOpts.mkPositiveInt 1 ''
          Padding from the left if max_len_align is true.
        '';

        right_align = defaultNullOpts.mkBool false ''
          Whether to align to the extreme right or not.
        '';

        right_align_padding = defaultNullOpts.mkPositiveInt 7 ''
          Padding from the right if `right_align` is true.
        '';

        highlight = defaultNullOpts.mkStr "Comment" "The color of the hints.";

        priority = defaultNullOpts.mkUnsignedInt 100 "The highlight group priority for extmark.";
      };

      ast = {
        role_icons =
          mapAttrs (name: default: defaultNullOpts.mkStr default "Icon for the `${name}` role.")
            {
              type = "🄣";
              declaration = "🄓";
              expression = "🄔";
              statement = ";";
              specifier = "🄢";
              "template argument" = "🆃";
            };

        kind_icons = mapAttrs (name: default: defaultNullOpts.mkStr default "`${name}` icon.") {
          Compound = "🄲";
          Cecovery = "🅁";
          TranslationUnit = "🅄";
          PackExpansion = "🄿";
          TemplateTypeParm = "🅃";
          TemplateTemplateParm = "🅃";
          TemplateParamObject = "🅃";
        };

        highlights = {
          detail = defaultNullOpts.mkStr "Comment" "The color of the hints.";
        };
      };

      memory_usage = {
        border = mkBorderOpt ''
          Border character for memory usage window.
        '';
      };

      symbol_info = {
        border = mkBorderOpt ''
          Border character for symbol info window.
        '';
      };
    };

  extraOptions = {
    enableOffsetEncodingWorkaround = lib.mkEnableOption ''
      UTF-16 offset encoding. This is used to work around the warning:
      "multiple different client offset_encodings detected for buffer, this is
      not supported yet".
    '';
  };

  extraConfig = cfg: {
    warnings = lib.optionals (!config.plugins.lsp.enable) ''
      Nixvim (plugins.clangd-extensions): You have enabled `clangd-extensions` but not the lsp (`plugins.lsp`).
      You should set `plugins.lsp.enable = true` to make use of the clangd-extensions' features.
    '';

    plugins.lsp = {
      servers.clangd = {
        enable = lib.mkDefault true;

        extraOptions = lib.mkIf cfg.enableOffsetEncodingWorkaround {
          capabilities.__raw = ''
            vim.tbl_deep_extend(
              "force",
              vim.lsp.protocol.make_client_capabilities(),
              {
                offsetEncoding = { "utf-16" }
              }
            )
          '';
        };
      };
    };
  };

  settingsExample = {
    inlay_hints = {
      inline = true;
    };
    ast = {
      role_icons = {
        type = "";
        declaration = "";
        expression = "";
        specifier = "";
        statement = "";
        "template argument" = "";
      };
    };
  };
}
