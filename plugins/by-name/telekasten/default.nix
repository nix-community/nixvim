{
  config,
  lib,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "telekasten";
  packPathName = "telekasten.nvim";
  package = "telekasten-nvim";

  maintainers = [ lib.maintainers.onemoresuza ];

  settingsExample = {
    home.__raw = ''vim.fn.expand("~/zettelkasten")'';
  };

  # TODO: Remove once nixpkgs #349346 lands, since it will have plenary-nvim as
  # a dependency.
  extraOptions = {
    plenaryPackage = lib.mkPackageOption pkgs.vimPlugins "plenary-nvim" { nullable = true; };
  };

  # TODO: Remove once nixpkgs #349346 lands, since it will have telescope-nvim
  # as a dependency.
  extraConfig = cfg: {
    assertions = [
      {
        assertion = config.plugins.telescope.enable;
        message = ''
          Nixvim (plugins.telekasten): The plugin needs telescope to function as intended.
        '';
      }
    ];
    extraPlugins = [ cfg.plenaryPackage ];
  };
}
