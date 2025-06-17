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
  description = "A Neovim plugin for working with a markdown zettelkasten/wiki and mixing it with a journal, based on telescope.nvim.";

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
    assertions = lib.nixvim.mkAssertions "plugins.telekasten" {
      assertion = config.plugins.telescope.enable;
      message = ''
        You have to enable `plugins.telescope` as `enableTelescope` is activated.
      '';
    };

    extraPlugins = [ cfg.plenaryPackage ];
  };
}
