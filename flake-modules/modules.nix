{modules, ...}: {
  _module.args = {
    modules = pkgs: let
      nixpkgsMaintainersList = pkgs.path + "/nixos/modules/misc/meta.nix";

      nixvimExtraArgsModule = rec {
        _file = ./flake.nix;
        key = _file;
        config = {
          _module.args = {
            pkgs = pkgs.lib.mkForce pkgs;
            inherit (pkgs) lib;
          };
        };
      };
    in [
      ../modules
      nixpkgsMaintainersList
      nixvimExtraArgsModule
      ({lib, ...}:
        with lib; {
          # Attribute may contain the following fields:
          #  - name: Name of the module
          #  - kind: Either colorschemes or plugins
          #  - url: Url for the plugin
          #
          #  [kind name] will identify the plugin
          #
          # We need to use an attrs instead of a submodule to handle the merge.
          options.meta.nixvimInfo = mkOption {
            type =
              (types.nullOr types.attrs)
              // {
                # This will create an attrset of the form:
                # {
                #    "path"."to"."plugin" = { "<name>" = <info>; };
                # }
                #
                # Where <info> is an attrset of the form:
                # {file = "path"; url = null or "<URL>";}
                merge = _: defs:
                  lib.foldl' (acc: def:
                    lib.recursiveUpdate acc {
                      "${def.value.kind}"."${def.value.name}" = {
                        inherit (def.value) url;
                        inherit (def) file;
                      };
                    }) {
                    plugins = {};
                    colorschemes = {};
                  }
                  defs;
              };
            internal = true;
            default = null;
            description = ''
              Nixvim related information on the module
            '';
          };
        })
    ];
  };

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    _module.args = {
      modules = modules pkgs;
      rawModules = modules;
    };
  };
}
