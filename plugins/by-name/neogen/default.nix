{
  lib,
  ...
}:
let
  keymapDef = {
    generate = {
      command = "";

      description = ''
        The only function required to use Neogen.

        It'll try to find the first parent that matches a certain type.
        For example, if you are inside a function, and called `generate({ type = "func" })`,
        Neogen will go until the start of the function and start annotating for you.
      '';
    };

    generateClass = {
      command = "class";
      description = "Generates annotation for class.";
    };

    generateFunction = {
      command = "func";
      description = "Generates annotation for function.";
    };

    generateType = {
      command = "type";
      description = "Generates annotation for type.";
    };

    generateFile = {
      command = "file";
      description = "Generates annotation for file.";
    };
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neogen";
  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: introduced 2025-10-03: remove after 26.05
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;

  settingsExample = {
    snippet_engine = "mini";
    languages = {
      lua.template.annotation_convention = "emmylua";
      python.template.annotation_convention = "numpydoc";
    };
  };

  extraOptions = {
    keymaps = lib.mapAttrs (
      optionsName: properties: lib.nixvim.mkNullOrOption lib.types.str properties.description
    ) keymapDef;

    keymapsSilent = lib.mkOption {
      type = lib.types.bool;
      description = "Whether Neogen keymaps should be silent";
      default = false;
    };
  };

  extraConfig = cfg: {
    keymaps = lib.flatten (
      lib.mapAttrsToList (
        optionName: properties:
        let
          key = cfg.keymaps.${optionName};
        in
        lib.optional (key != null) {
          mode = "n";
          inherit key;
          action = ":Neogen ${properties.command}<CR>";
          options.silent = cfg.keymapsSilent;
        }
      ) keymapDef
    );
  };
}
