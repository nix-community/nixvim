{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks.flakeModule
    ./devshell.nix
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;

    pre-commit = {
      settings.hooks = {
        alejandra.enable = true;
        statix = {
          enable = true;
          excludes = ["plugins/lsp/language-servers/rust-analyzer-config.nix"];
        };
        typos.enable = true;
      };
    };
  };
}
