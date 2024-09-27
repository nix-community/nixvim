{
  lib,
  helpers,
  config,
  ...
}:
let
  inherit (lib) types;

  cfg = config.filetype;

  filetypeDefinition = helpers.mkNullOrOption (
    with types;
    attrsOf (oneOf [
      # Raw filetype
      str
      # Function to set the filetype
      rawLua
      # ["filetype" {priority = xx;}]
      (listOf (
        either str (submodule {
          options = {
            priority = lib.mkOption {
              type = ints.unsigned;
              description = ''
                Filename patterns can specify an optional priority to resolve cases when a file path
                matches multiple patterns.

                Higher priorities are matched first.
                When omitted, the priority defaults to 0.

                A pattern can contain environment variables of the form `"''${SOME_VAR}"` that will
                be automatically expanded.
                If the environment variable is not set, the pattern won't be matched.
              '';
            };
          };
        })
      ))
    ])
  );
in
{
  options.filetype =
    helpers.mkCompositeOption
      ''
        Define additional filetypes. The values can either be a literal filetype or a function
        taking the filepath and the buffer number.

        For more information check `:h vim.filetype.add()`
      ''
      {
        extension = filetypeDefinition "set filetypes matching the file extension";
        filename = filetypeDefinition "set filetypes matching the file name (or path)";
        pattern = filetypeDefinition "set filetypes matching the specified pattern";
      };

  config.extraConfigLua =
    lib.mkIf (cfg != null && (builtins.any (v: v != null) (builtins.attrValues cfg)))
      ''
        vim.filetype.add(${helpers.toLuaObject cfg})
      '';
}
