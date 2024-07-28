{ lib, nixvimUtils, ... }:
{
  /**
    Produce a NixOS Module that warns users the option path is transitioning from one option to another.

    The primary use case is for adding a plugin variant,
    with the intention of it using the "primary" option path for that plugin.

    It is recommended that after transitioning, `lib.mkAliasOptionModule` is used,
    to avoid breaking configs that used the `to` path.

    If there's no plan to transition, just use `lib.mkRenamedOptionModule`.

    # Example
    ```nix
    mkTransitionOptionModule {
      from = [ "plugins" "surround" ];
      to = [ "plugins" "surround-vim" ];
      future = [ "plugins" "surround-nvim" ];
      takeover = "24.11";
    }
    => <nixos-module>
    ```

    # Type
    ```
    mkTransitionOptionModule :: AttrSet -> NixosModule
    ```
  */
  mkTransitionOptionModule =
    {
      # The path `to` used to be found at and `future` will eventually be moved to.
      from,
      # The option the alias points to, previously found at `from`.
      to,
      # The new option; will takeover `from` in the future
      future,
      # The date or release after which `future` will be moved to `from`.
      takeover ? lib.trivial.release,
    }:
    # Return a module
    {
      lib,
      options,
      config,
      ...
    }:
    let
      inherit (lib)
        setAttrByPath
        getAttrFromPath
        attrByPath
        showFiles
        showOption
        optional
        ;
      opt = getAttrFromPath from options;
      toOpt = getAttrFromPath to options;
    in
    {
      options = setAttrByPath from (
        lib.mkOption {
          description = "Alias of `${showOption to}`.";
          apply = attrByPath to (abort "Renaming error: option `${showOption to}' does not exist.") config;
          type = toOpt.type or (lib.types.submodule { });
          visible = false;
        }
      );

      config = lib.mkMerge [
        {
          warnings = optional opt.isDefined ''
            The option `${showOption from}' defined in ${showFiles opt.files} has been renamed to `${showOption to}'.
            This has been done to avoid confusion with the new option `${showOption future}'.

            At some point after ${takeover}, `${showOption future}' will be moved to `${showOption from}'.
          '';
        }
        (lib.modules.mkAliasAndWrapDefsWithPriority (setAttrByPath to) opt)
      ];
    };
}
