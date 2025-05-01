{ config, lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) mapAttrs;
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
    warnings = lib.nixvim.mkWarnings "plugins.clangd-extensions" {
      when = !(config.plugins.lsp.enable || config.lsp.servers.clangd.enable);

      message = ''
        You have enabled `clangd-extensions` but not the lsp (`plugins.lsp` or `lsp.servers.clangd`).
        You should set `plugins.lsp.enable = true` or `lsp.servers.clangd.enable = true` to make use of the clangd-extensions' features.
      '';
    };

    lsp = {
      servers.clangd = {
        settings = lib.mkIf cfg.enableOffsetEncodingWorkaround {
          capabilities = {
            offsetEncoding = [ "utf-16" ];
          };
        };
      };
    };

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
