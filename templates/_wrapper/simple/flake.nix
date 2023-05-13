{
  inputs = {
    nixvim.url = "path:../../..";
    # flake-utils = {
    #   url = "github:numtide/flake-utils";
    # };
    simple = {
      url = "path:../../simple";
      inputs.nixvim.follows = "nixvim";
      inputs.flake-utils.follows = "nixvim/flake-utils";
    };
  };

  outputs = inputs: inputs.simple;
}
