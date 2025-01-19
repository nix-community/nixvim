{ lib, config, ... }:
let
  cfg = config.nixvim;
in
{
  options.nixvim = {
    packages = {
      enable = lib.mkEnableOption "automatically installing packages for each nixvimConfigurations";
      nameFunction = lib.mkOption {
        type = lib.types.functionTo lib.types.str;
        description = ''
          A function to convert a nixvimConfiguration's name into a package name.

          **Type**

          ```
          String -> String
          ```
        '';
        default = name: "nixvim-" + name;
        defaultText = lib.literalExpression ''name: "nixvim-" + name'';
        example = lib.literalExpression ''name: name + "-nvim"'';
      };
    };
    checks = {
      enable = lib.mkEnableOption "automatically installing checks for each nixvimConfigurations";
      nameFunction = lib.mkOption {
        type = lib.types.functionTo lib.types.str;
        description = ''
          A function to convert a nixvimConfiguration's name into a check name.

          **Type**

          ```
          String -> String
          ```
        '';
        default = name: "nixvim-" + name;
        defaultText = lib.literalExpression ''name: "nixvim-" + name'';
        example = lib.literalExpression ''name: "nixvim-" + name + "-test"'';
      };
    };
  };
  config = {
    perSystem =
      { config, ... }:
      {
        packages = lib.mkIf cfg.packages.enable (
          lib.mapAttrs' (name: configuration: {
            name = cfg.packages.nameFunction name;
            value = configuration.config.build.package;
          }) config.nixvimConfigurations
        );
        checks = lib.mkIf cfg.checks.enable (
          lib.mapAttrs' (name: configuration: {
            name = cfg.checks.nameFunction name;
            value = configuration.config.build.test;
          }) config.nixvimConfigurations
        );
      };
  };
}
