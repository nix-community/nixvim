{
  flake.templates = {
    default = {
      path = ../templates/simple;
      description = "A simple nix flake template for getting started with nixvim";
    };
    new = {
      path = ../templates/experimental-flake-parts;
      description = "An experimental flake template for configuring nixvim using evalNixvim and flake.parts";
    };
  };
}
