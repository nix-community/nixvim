{ lib, pkgs, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "quarto";
  packPathName = "quarto-nvim";
  package = "quarto-nvim";

  maintainers = [ lib.maintainers.BoneyPatel ];

  settingsOptions = {
    debug = defaultNullOpts.mkBool false ''
      Enables or disables debugging.
    '';

    closePreviewOnExit = defaultNullOpts.mkBool true ''
      Closes preview on exit.
    '';

    lspFeatures = {
      enabled = defaultNullOpts.mkBool true ''
        Enables LSP features.
      '';

      chunks = defaultNullOpts.mkStr "curly" ''
        Sets chunk delimiter style.
      '';

      languages =
        defaultNullOpts.mkListOf types.str
          [
            "r"
            "python"
            "julia"
            "bash"
            "html"
          ]
          ''
            List of supported languages.
          '';

      diagnostics = {
        enabled = defaultNullOpts.mkBool true ''
          Enables diagnostics.
        '';

        triggers = defaultNullOpts.mkListOf types.str [ "BufWritePost" ] ''
          Sets triggers for diagnostics.
        '';
      };

      completion = {
        enabled = defaultNullOpts.mkBool true ''
          Enables completion.
        '';
      };
    };

    codeRunner = {
      enabled = defaultNullOpts.mkBool false ''
        Enables or disables the code runner.
      '';

      default_method =
        defaultNullOpts.mkEnum
          [
            "molten"
            "slime"
          ]
          null
          ''
            Sets the default code runner method. Either "molten", "slime", or `null`.
          '';

      ft_runners = defaultNullOpts.mkAttrsOf types.str { } ''
        Specifies filetype to runner mappings.
      '';

      never_run = defaultNullOpts.mkListOf types.str [ "yaml" ] ''
        List of filetypes that are never sent to a code runner.
      '';
    };
  };

  settingsExample = {
    debug = false;
    lspFeatures = {
      enabled = false;
      diagnostics = {
        enabled = true;
        triggers = [ "BufWritePost" ];
      };
    };
    codeRunner = {
      enabled = false;
      default_method = "vim-slime";
    };
  };
}
