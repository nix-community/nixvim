{
  inputs = {
    nixvim.url = "path:../../..";
    simple = {
      url = "path:../../simple";
      inputs = {
        nixvim.follows = "nixvim";
        nixpkgs.follows = "nixvim/nixpkgs";
        flake-parts.follows = "nixvim/flake-parts";
      };
    };
  };

  outputs = inputs: inputs.simple;
}
