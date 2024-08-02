{
  pkgs,
  lib,
  helpers,
}:
rec {
  # Minimal specialArgs required to evaluate nixvim modules
  specialArgs = specialArgsWith { };

  # Build specialArgs for evaluating nixvim modules
  specialArgsWith =
    extraSpecialArgs:
    {
      # TODO: deprecate `helpers`
      inherit lib helpers;
      defaultPkgs = pkgs;
    }
    // extraSpecialArgs;
}
