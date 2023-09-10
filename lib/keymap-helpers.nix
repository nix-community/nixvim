{lib, ...}:
with lib; rec {
  # Correctly merge two attrs (partially) representing a mapping.
  mergeKeymap = defaults: keymap: let
    # First, merge the `options` attrs of both options.
    mergedOpts = (defaults.options or {}) // (keymap.options or {});
  in
    # Then, merge the root attrs together and add the previously merged `options` attrs.
    (defaults // keymap) // {options = mergedOpts;};

  # Given an attrs of key mappings (for a single mode), applies the defaults to each one of them.
  #
  # Example:
  # mkModeMaps { silent = true; } {
  #   Y = "y$";
  #   "<C-c>" = { action = ":b#<CR>"; silent = false; };
  # };
  #
  # would give:
  # {
  #   Y = {
  #     action = "y$";
  #     silent = true;
  #   };
  #   "<C-c>" = {
  #     action = ":b#<CR>";
  #     silent = false;
  #   };
  # };
  mkModeMaps = defaults:
    mapAttrs
    (
      key: action: let
        actionAttrs =
          if isString action
          then {inherit action;}
          else action;
      in
        defaults // actionAttrs
    );

  # Applies some default mapping options to a set of mappings
  #
  # Example:
  #   maps = mkMaps { silent = true; expr = true; } {
  #     normal = {
  #       ...
  #     };
  #     visual = {
  #       ...
  #     };
  #   }
  mkMaps = defaults:
    mapAttrs
    (
      name: modeMaps:
        mkModeMaps defaults modeMaps
    );

  # TODO deprecate `mkMaps` and `mkModeMaps` and leave only this one
  mkKeymaps = defaults:
    map
    (mergeKeymap defaults);
}
