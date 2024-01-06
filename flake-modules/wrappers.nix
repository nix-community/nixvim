{
  modules,
  self,
  ...
}: let
  wrapperArgs = {
    inherit modules;
    inherit self;
  };
in {
  perSystem = {
    pkgs,
    pkgsUnfree,
    config,
    ...
  }: {
    _module.args = {
      makeNixvimWithModule =
        import ../wrappers/standalone.nix
        pkgs
        wrapperArgs;

      makeNixvimWithModuleUnfree =
        import ../wrappers/standalone.nix
        pkgsUnfree
        wrapperArgs;
    };
  };

  flake = {
    nixosModules.nixvim = import ../wrappers/nixos.nix wrapperArgs;
    homeManagerModules.nixvim = import ../wrappers/hm.nix wrapperArgs;
    nixDarwinModules.nixvim = import ../wrappers/darwin.nix wrapperArgs;
  };
}
