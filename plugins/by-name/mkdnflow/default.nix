{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mkdnflow";
  package = "mkdnflow-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    mappings = lib.nixvim.mkNullOrOption' {
      type = with lib.types; attrsOf anything;
      description = ''
        Key mappings for mkdnflow commands.

        Use the generated positional format for mapping entries:
        - `false` to disable a command mapping.
        - `[modes key]`, where `modes` is a string or list of mode strings.
      '';
      apply = lib.mapNullable (
        mappings:
        let
          isLegacyMapping = mapping: lib.isAttrs mapping && mapping ? modes && mapping ? key;

          legacyMappings = lib.filterAttrs (_: isLegacyMapping) mappings;

          normalizedMappings =
            mappings
            // lib.mapAttrs (_: mapping: [
              mapping.modes
              mapping.key
            ]) legacyMappings;
        in
        # TODO: Added 2026-02-11, remove after 27.05
        lib.warnIf (legacyMappings != { }) ''
          Nixvim (plugins.mkdnflow): Setting `plugins.mkdnflow.settings.mappings.<name> = { modes = ...; key = ...; }` is deprecated.
          Use `plugins.mkdnflow.settings.mappings.<name> = [ <modes> <key> ];` instead.
          Example:
            `MkdnEnter = [ [ "n" "i" ] "<CR>" ];`
          Legacy mappings in this definition: ${lib.concatStringsSep ", " (lib.attrNames legacyMappings)}
        '' normalizedMappings
      );
    };
  };

  settingsExample = {
    modules = {
      bib = false;
      yaml = true;
    };
    create_dirs = false;
    perspective = {
      priority = "root";
      root_tell = ".git";
    };
    links = {
      style = "wiki";
      conceal = true;
    };
    to_do = {
      symbols = [
        "✗"
        "◐"
        "✓"
      ];
    };
  };

  # TODO: Deprecated 2025-10-04
  inherit (import ./deprecations.nix)
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
