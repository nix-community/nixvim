{
  description = "A set of test configurations for nixvim";

  inputs.nixvim.url = "./..";

  outputs = { self, nixvim, ... }: rec {
    # A plain nixvim configuration
    plain = nixvim.build { };
  };
}
