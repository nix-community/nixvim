{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-surround";
  packPathName = "nvim-surround";
  package = "nvim-surround";

  maintainers = with lib.maintainers; [
    khaneliman
    AndresBermeoMarinelli
  ];

  settingsOptions = {
    keymaps = defaultNullOpts.mkAttrsOf types.str ''
      {
        insert = "<C-g>s";
        insert_line = "<C-g>S";
        normal = "ys";
        normal_cur = "yss";
        normal_line = "yS";
        normal_cur_line = "ySS";
        visual = "S";
        visual_line = "gS";
        delete = "ds";
        change = "cs";
        change_line = "cS";
      }
    '' "Defines the keymaps used to perform surround actions.";

    aliases = defaultNullOpts.mkAttrsOf (with types; either str (listOf str)) ''
      {
        "a" = ">";
        "b" = ")";
        "B" = "}";
        "r" = "]";
        "q" = [ "\"" "'" "`" ];
        "s" = [ "}" "]" ")" ">" "\"" "'" "`" ];
      }
    '' "Maps characters to other characters, or lists of characters.";

    surrounds =
      let
        surroundType = types.submodule {
          options = {
            add = lib.mkOption {
              type = with types; either strLuaFn (listOf str);
              description = ''
                A function that returns the delimiter pair to be added to the buffer.
                For "static" delimiter pairs it can be a list of strings representing the value
                of the delimiter pair.
              '';
              example = [
                "( "
                " )"
              ];
            };
            find = lib.mkOption {
              type = with types; maybeRaw str;
              description = ''
                A function that returns the "parent selection" for a surrounding pair.
                It can also be string which is interpreted as a Lua pattern that represents the
                selection.
              '';
              example.__raw = ''
                function()
                  return M.get_selection({ motion = "a(" })
                end
              '';
            };
            delete = lib.mkOption {
              type = with types; maybeRaw str;
              description = ''
                A function that returns the pair of selections to remove from the buffer when
                deleting the surrounding pair.
                It can also be string which is interpreted as a Lua pattern whose match groups
                represent the left/right delimiter pair.
              '';
              example = "^(. ?)().-( ?.)()$";
            };

            change = lib.nixvim.mkNullOrOption (types.submodule {
              options = {
                target = lib.mkOption {
                  type = with types; maybeRaw str;
                  description = ''
                    A function that returns the pair of selections to be replaced in the buffer
                    when changing the surrounding pair.
                    It can also be a string which is interpreted as a Lua pattern whose match
                    groups represent the left/right delimiter pair.
                  '';
                  example = "^<([^>]*)().-([^%/]*)()>$";
                };
                replacement = lib.mkOption {
                  type = types.rawLua;
                  description = ''
                    A function that returns the surrounding pair to replace the target
                    selections.
                  '';
                  example.__raw = ''
                    function()
                        local result = M.get_input("Enter the function name: ")
                        if result then
                            return { { result }, { "" } }
                        end
                    end
                  '';
                };
              };
            }) "An attribute set with two keys: `target` and `replacement`.";
          };
        };
      in
      lib.nixvim.mkNullOrOption' {
        type = with types; attrsOf (maybeRaw surroundType);
        description = ''
          Associates each key with a "surround". The attribute set contains
          the 'add', 'find', 'delete', and 'change' keys.
        '';
        pluginDefault = lib.literalMD "See [upstream default configuration](https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua)";
      };
  };
}
