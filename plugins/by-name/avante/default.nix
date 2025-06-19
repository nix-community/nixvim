{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption';
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "avante";
  packPathName = "avante.nvim";
  package = "avante-nvim";
  description = "A Neovim plugin designed to emulate the behaviour of the Cursor AI IDE.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    provider = defaultNullOpts.mkStr "claude" ''
      The LLM provider (`"claude"`, `"openai"`, `"azure"`, ...)
    '';

    auto_suggestions_provider = defaultNullOpts.mkStr "claude" ''
      The provider for automatic suggestions.

      Since auto-suggestions are a high-frequency operation and therefore expensive, it is
      recommended to specify an inexpensive provider or even a free provider: `"copilot"`.
    '';

    mappings = mkNullOrOption' {
      description = ''
        Key mappings for various functionalities within avante.
      '';
      type = with lib.types; attrsOf (either str (attrsOf str));
      example = {
        diff = {
          ours = "co";
          theirs = "ct";
          none = "c0";
          both = "cb";
          next = "]x";
          prev = "[x";
        };
        jump = {
          next = "]]";
          prev = "[[";
        };
      };
    };
  };

  settingsExample = {
    provider = "claude";
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com";
        model = "claude-3-5-sonnet-20240620";
        extra_request_body = {
          temperature = 0;
          max_tokens = 4096;
        };
      };
    };
    mappings = {
      diff = {
        ours = "co";
        theirs = "ct";
        none = "c0";
        both = "cb";
        next = "]x";
        prev = "[x";
      };
    };
    hints.enabled = true;
    windows = {
      wrap = true;
      width = 30;
      sidebar_header = {
        align = "center";
        rounded = true;
      };
    };
    highlights.diff = {
      current = "DiffText";
      incoming = "DiffAdd";
    };
    diff = {
      debug = false;
      autojump = true;
      list_opener = "copen";
    };
  };

  extraConfig = {
    plugins.avante.luaConfig.pre = ''
      require('avante_lib').load()
    '';
  };
}
