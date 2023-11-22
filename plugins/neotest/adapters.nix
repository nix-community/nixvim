{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib; let
  supportedAdapters = import ./adapters-list.nix;

  mkAdapter = name: props: {
    options.plugins.neotest.adapters.${name} = {
      enable = mkEnableOption name;

      package = helpers.mkPackageOption name pkgs.vimPlugins."neotest-${name}";

      settings = helpers.mkSettingsOption {
        description = "settings for the `${name}` adapter.";
      };
    };

    config = let
      cfg = config.plugins.neotest.adapters.${name};
    in
      mkIf cfg.enable {
        extraPlugins = [cfg.package];

        warnings =
          optional
          (!config.plugins.treesitter.enable)
          ''
            Nixvim (plugins.neotest.adapters.${name}): This adapter requires `treesitter` to be enabled.
            You might want to set `plugins.treesitter.enable = true` and ensure that the `${props.treesitter-parser}` is enabled.
          '';

        plugins.neotest.enabledAdapters = [
          {
            inherit name;
            inherit (cfg) settings;
          }
        ];
      };
  };
in {
  imports = mapAttrsToList mkAdapter supportedAdapters;
}
