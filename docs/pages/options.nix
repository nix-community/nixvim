{ configuration }:
{ lib, ... }:
let
  # Sort option-owners by longest path-prefix first
  owners = lib.pipe configuration.config.meta.nixvimInfo [
    (lib.mapAttrsToList (name: info: info // { inherit name; }))
    (lib.sortOn (info: builtins.length info.path))
    lib.reverseList
  ];

  ownerForOption = option: lib.findFirst (info: lib.lists.hasPrefix info.path option.loc) null owners;
  ownerNameForOption = option: (ownerForOption option).name or "__otherOptions";

  renderMaintainer = m: if m ? github then "[${m.name}](https://github.com/${m.github})" else m.name;

  optionsByOwner = builtins.groupBy ownerNameForOption (
    lib.optionAttrSetToDocList configuration.options
  );
  optionPageModules = lib.mapAttrsToList (
    name: options:
    let
      info = configuration.config.meta.nixvimInfo.${name} or null;
      description = info.description or null;
      url = info.url or null;

      # We _could_ collect maintainers from _all_ option-declaring file, instead of just the nixvim-info file?
      # maintainers = lib.concatMap (opt: map (file: configuration.config.meta.maintainers.${info.file}) opt.declarations) options;
      maintainers = lib.optionals (info != null) (
        configuration.config.meta.maintainers.${info.file} or [ ]
      );
    in
    {
      config = lib.setAttrByPath ([ "options" ] ++ info.path or [ ]) {
        _page = {
          title = if info == null then "Options" else lib.showOption info.path;
          content =
            lib.optional (url != null) {
              text = "**URL:** <${url}>\n\n";
            }
            ++ lib.optional (maintainers != [ ]) {
              text = "**Maintainers:** ${lib.concatMapStringsSep ", " renderMaintainer maintainers}\n\n";
            }
            ++ lib.optional (description != null && (url != null || maintainers != [ ])) {
              text = "\n\n---\n\n";
            }
            ++ lib.optional (description != null) {
              text = description;
            }
            ++ lib.singleton { inherit options; };
        };
      };
    }
  ) optionsByOwner;
in
{
  config.options = {
    config._category.name = "Options";
    imports = optionPageModules;
  };
}
