{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks.flakeModule
  ];

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      shellHook = config.pre-commit.installationScript;
    };

    formatter = pkgs.alejandra;

    pre-commit = {
      settings.hooks = {
        alejandra.enable = true;
        statix = {
          enable = true;
          excludes = [
            "plugins/lsp/language-servers/rust-analyzer-config.nix"
          ];
        };
      };
    };
  };
}
