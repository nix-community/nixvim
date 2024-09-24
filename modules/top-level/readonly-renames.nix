{ lib, options, ... }:
let
  # Recursively maps an attrset of option-refs into an attrset of option alias declarations.
  #
  # NOTE: `mkRenameOptionModule` is not appropriate for readOnly options, and we don't need a full two-way alias anyway (since it is read only).
  toReadOnlyRenameOptions =
    let
      mkAlias =
        from: toOpt:
        assert lib.assertMsg toOpt.readOnly
          "toReadOnlyRenameOptions used on non-readOnly option `${lib.showOption toOpt.loc}'.";
        assert lib.assertMsg toOpt.isDefined
          "toReadOnlyRenameOptions used on undefined option `${lib.showOption toOpt.loc}'.";
        lib.mkOption {
          inherit (toOpt) type;
          default = toOpt.value;
          apply = lib.warn "Obsolete option `${lib.showOption from}' is used. It was renamed to `${lib.showOption toOpt.loc}'.";
          description = "Alias of {option}`${lib.showOption toOpt.loc}`.";
          readOnly = true;
          visible = false;
        };

      go =
        path: name: opt:
        let
          loc = path ++ lib.singleton name;
        in
        if lib.isOption opt then mkAlias loc opt else lib.mapAttrs (go loc) opt;
    in
    lib.mapAttrs (go [ ]);
in
{
  # TODO: Added 2024-09-24; remove after 24.11
  options = toReadOnlyRenameOptions {
    inherit (options.build) printInitPackage;
    finalPackage = options.build.package;
    initPath = options.build.initFile;
    filesPlugin = options.build.extraFiles;
    test.derivation = options.build.test;
  };
}
