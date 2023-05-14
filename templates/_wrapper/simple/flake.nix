{
  inputs = {
    nixvim.url = "path:../../..";
    simple = {
      url = "path:../../simple";
      inputs.nixvim.follows = "nixvim";
      inputs.flake-utils.follows = "nixvim/flake-utils";
    };
  };

  outputs = inputs: inputs.simple;
}
