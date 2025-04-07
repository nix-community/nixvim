{
  config,
  lib,
  helpers,
  ...
}:
with lib;
let
  settingsOptions = {
    fzf_bin = helpers.mkNullOrStr ''
      The path to the `fzf` binary to use.

      Example: `"skim"`
    '';
  };
  settingsExample = {
    winopts = {
      height = 0.4;
      width = 0.93;
      row = 0.99;
      col = 0.3;
    };
    files = {
      find_opts.__raw = "[[-type f -not -path '*.git/objects*' -not -path '*.env*']]";
      prompt = "Files❯ ";
      multiprocess = true;
      file_icons = true;
      color_icons = true;
    };
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "fzf-lua";

  maintainers = [ maintainers.GaetanLepage ];

  inherit settingsOptions settingsExample;

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "fzf-lua";
      packageName = "fzf";
    })
  ];

  extraOptions = {
    # TODO: deprecated 2024-08-29 remove after 24.11
    iconsEnabled = mkOption {
      type = types.bool;
      description = "Toggle icon support. Installs nvim-web-devicons.";
      visible = false;
    };

    profile = helpers.defaultNullOpts.mkEnumFirstDefault [
      "default"
      "fzf-native"
      "fzf-tmux"
      "fzf-vim"
      "max-perf"
      "telescope"
      "skim"
    ] "Preconfigured profile to use";

    keymaps = mkOption {
      type =
        with types;
        attrsOf (
          either str (submodule {
            options = {
              action = mkOption {
                type = types.str;
                description = "The `fzf-lua` action to run";
                example = "git_files";
              };
              settings = helpers.mkSettingsOption {
                options = settingsOptions;
                description = "`fzf-lua` settings for this command.";
                example = settingsExample;
              };
              mode = helpers.keymaps.mkModeOption "n";
              options = helpers.keymaps.mapConfigOptions;
            };
          })
        );
      description = "Keymaps for Fzf-Lua.";
      default = { };
      example = lib.literalExpression ''
        {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            settings = {
              previewers.cat.cmd = lib.getExe' pkgs.coreutils "cat";
              winopts.height = 0.5;
            };
            options = {
              silent = true;
              desc = "Fzf-Lua Git Files";
            };
          };
        };
      '';
    };
  };

  extraConfig = cfg: opts: {
    # TODO: deprecated 2024-08-29 remove after 24.11
    warnings = lib.nixvim.mkWarnings "plugins.fzf-lua" {
      when = opts.iconsEnabled.isDefined;

      message = ''
        The option definition `plugins.fzf-lua.iconsEnabled' in ${lib.showFiles opts.iconsEnabled.files} has been deprecated; please remove it.
      '';
    };

    # TODO: added 2024-09-20 remove after 24.11
    plugins.web-devicons =
      lib.mkIf
        (
          opts.iconsEnabled.isDefined
          && cfg.iconsEnabled
          && !(
            config.plugins.mini.enable
            && config.plugins.mini.modules ? icons
            && config.plugins.mini.mockDevIcons
          )
        )
        {
          enable = lib.mkOverride 1490 true;
        };

    dependencies.fzf.enable = lib.mkDefault true;

    plugins.fzf-lua.settings.__unkeyed_profile = cfg.profile;

    keymaps = mapAttrsToList (
      key: mapping:
      let
        actionStr =
          if isString mapping then
            "${mapping}()"
          else
            "${mapping.action}(${lib.nixvim.toLuaObject mapping.settings})";
      in
      {
        inherit key;
        mode = mapping.mode or "n";
        action.__raw = "function() require('fzf-lua').${actionStr} end";
        options = mapping.options or { };
      }
    ) cfg.keymaps;
  };
}
