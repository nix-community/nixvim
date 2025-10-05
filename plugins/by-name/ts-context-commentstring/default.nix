{
  lib,
  config,
  options,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "ts-context-commentstring";
  package = "nvim-ts-context-commentstring";
  moduleName = "ts_context_commentstring";
  description = "Treesitter plugin for setting the commentstring based on the cursor location in a file.";
  maintainers = [ ];

  # TODO: introduced 2025-10-05: remove after 26.05
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;

  extraOptions = {
    skipTsContextCommentStringModule = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to skip backwards compatibility routines and speed up loading.
      '';
      example = false;
    };

    disableAutoInitialization = lib.nixvim.defaultNullOpts.mkBool false ''
      Whether to disable auto-initialization.
    '';
  };

  settingsExample = {
    enable_autocmd = false;
    languages = {
      haskell = "-- %s";
      nix = {
        __default = "# %s";
        __multiline = "/* %s */";
      };
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.ts-context-commentstring" {
      when = !config.plugins.treesitter.enable;
      message = ''
        This plugin needs Treesitter to function as intended.
        Please, enable it by setting `${options.plugins.treesitter.enable}` to `true`.
      '';
    };

    globals = {
      skip_ts_context_commentstring_module = cfg.skipTsContextCommentStringModule;
      loaded_ts_context_commentstring = cfg.disableAutoInitialization;
    };
  };
}
