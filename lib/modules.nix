{
  lib,
  self,
  flake,
}:
let
  removed = {
    # Removed 2024-09-24
    getAssertionMessages = "";
    # Removed 2024-09-27
    specialArgs = "It has been integrated into `evalNixvim`";
    specialArgsWith = "It has been integrated into `evalNixvim`";
    # Removed 2024-12-18
    applyExtraConfig = "It has been moved to `lib.plugins.utils`";
    mkConfigAt = "It has been moved to `lib.plugins.utils`";
  };
  internal = lib.mkOption { internal = true; };
in
{
  # Evaluate nixvim modules, checking warnings and assertions
  evalNixvim =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
      system ? null, # Can also be defined using the `nixpkgs.hostPlatform` option
    }:
    # Ensure a suitable `lib` is used
    assert lib.assertMsg (extraSpecialArgs ? lib -> extraSpecialArgs.lib ? nixvim) ''
      Nixvim requires a lib that includes some custom extensions, however the `lib` from `specialArgs` does not have a `nixvim` attr.
      Remove `lib` from nixvim's `specialArgs` or ensure you apply nixvim's extensions to your `lib`.
      See https://nix-community.github.io/nixvim/user-guide/helpers.html#using-a-custom-lib-with-nixvim'';
    assert lib.assertMsg (system != null -> lib.isString system) ''
      When `system` is supplied to `evalNixvim`, it must be a string.
      To define a more complex system, please use nixvim's `nixpkgs.hostPlatform` option.'';
    lib.evalModules {
      modules = modules ++ [
        ../modules/top-level
        {
          _file = "<nixvim-flake>";
          flake = lib.mkOptionDefault flake;
        }
        (lib.optionalAttrs (system != null) {
          _file = "evalNixvim";
          nixpkgs.hostPlatform = lib.mkOptionDefault { inherit system; };
        })
      ];
      specialArgs = {
        # NOTE: we shouldn't have to set `specialArgs.lib`,
        # however see https://github.com/nix-community/nixvim/issues/2879
        inherit lib;
        modulesPath = ../modules;
        # TODO: deprecate `helpers`
        helpers = self;
      } // extraSpecialArgs;
    };

  # Create a module configuring a plugin's integration with blink.cmp
  mkBlinkPluginModule =
    {
      # The plugin's option location-path
      loc ? [
        "plugins"
        pluginName
      ],
      # Name of the plugin, used in documentation
      pluginName,
      # Name of the module blink should import
      # i.e. `sources.providers.<name>.module`
      module ? pluginName,
      # The default for `blink.settings.name`
      # i.e. `sources.providers.<name>.name`
      # TODO: consider doing some pre-processing to the default source name,
      # e.g. removing `-cmp` or `blink-` prefix/suffix?
      sourceName,
      # The default for `blink.key`
      # i.e. the attr name for `sources.providers.<name>`
      key ? lib.strings.toLower sourceName,
      # Whether to enable the blink completion provider by default
      enableProvider ? true,
      # Defaults for the corresponding source options
      enableDefault ? true,
      enableCmdline ? false,
      enabledFiletypes ? { },
      # Whether the plugin's settings should be used as the provider's `opts`
      usePluginSettings ? true,
      settingsExample ? {
        score_offset = -7;
        fallbacks = [ ];
      },
    }:
    { config, options, ... }:
    let
      pluginCfg = lib.getAttrFromPath loc config;
      cfg = pluginCfg.blink;
      pluginOpts = lib.getAttrFromPath loc options;
      opt = pluginOpts.blink;
    in
    {
      options = lib.setAttrByPath loc {
        blink = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = enableProvider;
            example = !enableProvider;
            description = ''
              Whether to integrate this plugin with blink.cmp.
            '';
          };
          key = lib.mkOption {
            type = lib.types.str;
            default = key;
            description = ''
              The key to use for ${pluginName}'s blink.cmp provider.
              This is the id you should use when including this provider in completion source lists.
              Must be unique.
            '';
          };
          default = lib.mkOption {
            type = lib.types.bool;
            default = enableDefault;
            example = !enableDefault;
            description = ''
              Whether to include this plugin in the `default` completion source list.
            '';
          };
          cmdline = lib.mkOption {
            type = lib.types.bool;
            default = enableCmdline;
            example = !enableCmdline;
            description = ''
              Whether to include this plugin in the `cmdline` completion source list.
            '';
          };
          filetypes = lib.mkOption {
            type = lib.types.attrsOf lib.types.bool;
            # Only include `true` attrs in the final value
            apply = lib.filterAttrs (_: lib.id);
            default = enabledFiletypes;
            # TODO: example
            description = ''
              Whether to include this plugin in the specific `per_filetype` completion source lists.
            '';
          };
          settings = lib.mkOption {
            default = { };
            description = ''
              Settings for the blink.cmp completion provider.
            '';
            example = settingsExample;
            type = lib.types.submodule [
              {
                options.enabled = internal;
                options.module = internal;
              }
              ../plugins/by-name/blink-cmp/provider-config.nix
            ];
          };
        };
      };
      config = lib.mkMerge [
        (lib.setAttrByPath loc {
          # NOTE: this could be defined within the `blink.settings` submodule,
          # but that would not populate the option's `definitions` list.
          # Meaning we wouldn't be able to propagate the definitions further using `mkAliasDefinitions`.
          blink.settings = {
            name = lib.mkDefault sourceName;
            inherit module;
            opts = lib.mkIf usePluginSettings (lib.modules.mkAliasDefinitions pluginOpts.settings);
          };
        })
        (lib.mkIf (pluginCfg.enable && cfg.enable) {
          plugins.blink-cmp.settings.sources = {
            # Use mkAliasDefinitions to preserve override priorities
            providers.${cfg.key} = lib.modules.mkAliasDefinitions opt.settings;
            default = lib.mkIf cfg.default [ cfg.key ];
            # FIXME: the reference shows `cmdline` should/could be defined as a function
            # https://cmp.saghen.dev/configuration/reference.html#sources
            cmdline = lib.mkIf cfg.cmdline [ cfg.key ];
            per_filetype = lib.mkIf (cfg.filetypes != { }) (
              builtins.mapAttrs (_: _: [ cfg.key ]) cfg.filetypes
            );
          };
          warnings = lib.nixvim.mkWarnings (lib.showOption loc) {
            when = !config.plugins.blink-cmp.enable && options.plugins.blink-cmp.enable.highestPrio == 1500;
            message = ''
              You have enabled the blink.cmp provider, but `plugins.blink-cmp` is not enabled.
              You can suppress this warning by explicitly setting `plugins.blink-cmp.enable = false`.
            '';
          };
        })
      ];
    };

  # Create a module configuring a plugin's integration with nvim-cmp and blink.cmp
  mkCmpPluginModule =
    {
      # The plugin's option location-path
      loc ? [
        "plugins"
        pluginName
      ],
      # Name of the plugin, used in documentation
      pluginName,
      # The nvim-cmp source name
      # TODO: can we compute a sane default for sourceName?
      sourceName,
      # Defaults for the corresponding cmp options
      enableDefault ? true,
      enableCmdline ? { },
      enabledFiletypes ? { },
      # Whether to include a `blink` option at all
      offerBlinkCompatibility ? true,
      # Defaults for the blink compatibility option
      enableBlinkProvider ? false,
      enableBlinkDefault ? false,
      enableBlinkCmdline ? false,
      enabledBlinkFiletypes ? { },
      # Whether the plugin's settings should be used as the blink provider's `opts`
      usePluginSettingsForBlink ? false,
      # The key to use with blink,
      # i.e. the attr name for `sources.providers.<name>`
      # TODO: should this default to pluginName or sourceName?
      blinkProviderKey ? lib.strings.toLower pluginName,
    }:
    { config, options, ... }:
    let
      pluginOpt = lib.getAttrFromPath loc options;
      pluginCfg = lib.getAttrFromPath loc config;
      blinkOpt = pluginOpt.blink;
      blinkCfg = pluginCfg.blink;
      cfg = pluginCfg.cmp;
      toSourceDef = v: lib.optionalAttrs (builtins.isAttrs v) v // { inherit (cfg) name; };
      toSources = v: { sources = [ (toSourceDef v) ]; };
    in
    {
      imports = lib.optionals offerBlinkCompatibility [
        (lib.nixvim.modules.mkBlinkPluginModule {
          inherit loc pluginName sourceName;
          key = blinkProviderKey;
          module = "blink.compat.source";
          enableProvider = enableBlinkProvider;
          enableDefault = enableBlinkDefault;
          enableCmdline = enableBlinkCmdline;
          enabledFiletypes = enabledBlinkFiletypes;
          usePluginSettings = usePluginSettingsForBlink;
        })
        {
          options = lib.setAttrByPath loc {
            blink.settings.name = internal;
          };
          config = lib.mkIf (pluginCfg.enable && blinkCfg.enable) {
            # Enable blink-compat if the plugin has `blink.enable = true`
            plugins.blink-compat.enable = true;
            # This warning will show if someone overrides `plugins.blink-compat.enable = mkForce false`
            warnings = lib.nixvim.mkWarnings (lib.showOption loc) {
              when = !config.plugins.blink-compat.enable;
              message = ''
                `${blinkOpt.enable}` is enabled, but `${options.plugins.blink-compat.enable}` is not.
                This plugin is a nvim-cmp source, so it requires blink.compat when used with blink.cmp.
              '';
            };
          };
        }
      ];
      options = lib.setAttrByPath loc {
        cmp = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = false;
            description = ''
              Whether to integrate this plugin with nvim-cmp.
            '';
          };
          name = lib.mkOption {
            type = lib.types.str;
            default = sourceName;
            description = "${pluginName}'s nvim-cmp source name.";
            internal = true;
          };
          default = lib.mkOption {
            type = with lib.types; either bool (attrsOf anything);
            default = enableDefault;
            example = !enableDefault;
            description = ''
              Whether to include this plugin in the `default` completion source list.

              Can be defined as attrs to pass additional config to the source.
            '';
          };
          cmdline = lib.mkOption {
            type = with lib.types; attrsOf (either bool (attrsOf anything));
            # Remove false attrs in the final value
            apply = lib.filterAttrs (_: v: v != false);
            default = enableCmdline;
            # TODO: example
            description = ''
              Whether to include this plugin in the specific `cmdline` completion source lists.

              Elements can be defined as attrs to pass additional config to the source.
            '';
          };
          filetypes = lib.mkOption {
            type = with lib.types; attrsOf (either bool (attrsOf anything));
            # Remove false attrs in the final value
            apply = lib.filterAttrs (_: v: v != false);
            default = enabledFiletypes;
            # TODO: example
            description = ''
              Whether to include this plugin in the specific `per_filetype` completion source lists.

              Elements can be defined as attrs to pass additional config to the source.
            '';
          };
        };
      };
      config = lib.mkIf (pluginCfg.enable && cfg.enable) {
        plugins.cmp = {
          settings = lib.mkIf (cfg.default != false) (toSources cfg.default);
          cmdline = lib.mkIf (cfg.cmdline != { }) (builtins.mapAttrs (_: toSources) cfg.cmdline);
          filetype = lib.mkIf (cfg.filetypes != { }) (builtins.mapAttrs (_: toSources) cfg.filetypes);
        };
        warnings = lib.nixvim.mkWarnings (lib.showOption loc) {
          when = !config.plugins.cmp.enable && options.plugins.cmp.enable.highestPrio == 1500;
          message = ''
            You have enabled the nvim-cmp source, but `plugins.cmp` is not enabled.
            You can suppress this warning by explicitly setting `plugins.cmp.enable = false`.
          '';
        };
      };
    };
}
// lib.mapAttrs (
  name: msg:
  throw ("`modules.${name}` has been removed." + lib.optionalString (msg != "") (" " + msg))
) removed
