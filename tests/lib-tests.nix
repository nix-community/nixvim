# For shorter test iterations run the following in the root of the repo:
#   `echo ':b checks.${builtins.currentSystem}.lib-tests' | nix repl .`
{
  lib,
  pkgs,
  helpers,
}:
let
  luaNames = {
    # Keywords in lua 5.1
    keywords = [
      "and"
      "break"
      "do"
      "else"
      "elseif"
      "end"
      "false"
      "for"
      "function"
      "if"
      "in"
      "local"
      "nil"
      "not"
      "or"
      "repeat"
      "return"
      "then"
      "true"
      "until"
      "while"
    ];
    identifiers = [
      "validIdentifier"
      "valid_identifier"
      "_also_valid_"
      "_weirdNameFMT"
    ];
    other = [
      "1_starts_with_digit"
      "01234"
      "12340"
      "kebab-case"
    ];
  };

  drv = pkgs.writeText "example-derivation" "hello, world!";

  results = pkgs.lib.runTests {
    testToLuaObject = {
      expr = helpers.toLuaObject {
        foo = "bar";
        qux = [
          1
          2
          3
        ];
      };
      expected = ''{ foo = "bar", qux = { 1, 2, 3 } }'';
    };

    testToLuaObjectRawLua = {
      expr = helpers.toLuaObject { __raw = "<lua code>"; };
      expected = "<lua code>";
    };

    testToLuaObjectInlineLua = {
      expr = helpers.toLuaObject (lib.generators.mkLuaInline "<lua code>");
      expected = "(<lua code>)";
    };

    testToLuaObjectInlineLuaNested = {
      expr = helpers.toLuaObject { lua = lib.generators.mkLuaInline "<lua code>"; };
      expected = "{ lua = (<lua code>) }";
    };

    testToLuaObjectLuaTableMixingList = {
      expr = helpers.toLuaObject {
        "__unkeyed...." = "foo";
        bar = "baz";
      };
      expected = ''{ "foo", bar = "baz" }'';
    };

    testToLuaObjectNestedAttrs = {
      expr = helpers.toLuaObject {
        a = {
          b = 1;
          c = 2;
          d = {
            e = 3;
          };
        };
      };
      expected = ''{ a = { b = 1, c = 2, d = { e = 3 } } }'';
    };

    testToLuaObjectNestedList = {
      expr = helpers.toLuaObject [
        1
        2
        [
          3
          4
          [
            5
            6
          ]
        ]
        7
      ];
      expected = "{ 1, 2, { 3, 4, { 5, 6 } }, 7 }";
    };

    testToLuaObjectNonStringPrims = {
      expr = helpers.toLuaObject {
        a = 1.0;
        b = 2;
        c = true;
        d = false;
        e = null;
      };
      expected = ''{ a = 1.0, b = 2, c = true, d = false }'';
    };

    testToLuaObjectNilPrim = {
      expr = helpers.toLuaObject null;
      expected = "nil";
    };

    testToLuaObjectStringPrim = {
      expr = helpers.toLuaObject ''
        foo\bar
        baz'';
      expected = ''"foo\\bar\nbaz"'';
    };

    testToLuaObjectDerivation = {
      expr = helpers.toLuaObject drv;
      expected = ''"${drv}"'';
    };

    testToLuaObjectDerivationNested = {
      expr = helpers.toLuaObject {
        a = drv;
        b = {
          c = drv;
        };
        d = [ drv ];
        e = [ { f = drv; } ];
      };
      expected = ''{ a = "${drv}", b = { c = "${drv}" }, d = { "${drv}" }, e = { { f = "${drv}" } } }'';
    };

    testToLuaObjectFilters = {
      expr = helpers.toLuaObject {
        a = null;
        b = { };
        c = [ ];
        d = {
          e = null;
          f = { };
        };
      };
      expected = ''{ }'';
    };

    testToLuaObjectAttrListFilters = {
      expr = helpers.toLuaObject {
        a = null;
        b = { };
        c = [ ];
        d = {
          e = null;
          f = { };
        };
        g = [
          {
            x = null;
            y = null;
            z = null;
          }
          {
            x = { };
            y = [ ];
            z = null;
          }
        ];
        __unkeyed-1 = [
          {
            x = null;
            y = null;
            z = null;
          }
          {
            x = { };
            y = [ ];
            z = null;
          }
          [
            {
              x = null;
              y = null;
              z = null;
            }
            {
              x = { };
              y = [ ];
              z = null;
            }
          ]
        ];
      };
      expected = ''{ { { }, { }, { { }, { } } }, g = { { }, { } } }'';
    };

    testToLuaObjectEmptyTable = {
      expr = helpers.toLuaObject {
        a = null;
        b = { };
        c = {
          __empty = null;
        };
        d = {
          e = null;
          f = { };
          g = helpers.emptyTable;
        };
      };
      expected = ''{ c = { }, d = { g = { } } }'';
    };

    testToLuaObjectEmptyListEntries = {
      expr = helpers.lua.toLua' { removeEmptyListEntries = true; } [
        { }
        [ ]
        [ { } ]
        null
        1
        2
        [
          null
          3
          4
          { }
          [ ]
          [ { } ]
        ]
        5
      ];
      expected = "{ nil, 1, 2, { nil, 3, 4 }, 5 }";
    };

    testToLuaObjectNullListEntries = {
      expr = helpers.lua.toLua' { removeNullListEntries = true; } [
        null
        1
        2
        [
          null
          3
          4
          [
            null
            5
            6
          ]
        ]
        7
      ];
      expected = "{ 1, 2, { 3, 4, { 5, 6 } }, 7 }";
    };

    testIsLuaKeyword = {
      expr = builtins.mapAttrs (_: builtins.filter helpers.lua.isKeyword) luaNames;
      expected = {
        keywords = [
          "and"
          "break"
          "do"
          "else"
          "elseif"
          "end"
          "false"
          "for"
          "function"
          "if"
          "in"
          "local"
          "nil"
          "not"
          "or"
          "repeat"
          "return"
          "then"
          "true"
          "until"
          "while"
        ];
        identifiers = [ ];
        other = [ ];
      };
    };

    testIsLuaIdentifier = {
      expr = builtins.mapAttrs (_: builtins.filter helpers.lua.isIdentifier) luaNames;
      expected = {
        keywords = [ ];
        identifiers = [
          "validIdentifier"
          "valid_identifier"
          "_also_valid_"
          "_weirdNameFMT"
        ];
        other = [ ];
      };
    };

    testUpperFirstChar = {
      expr = map helpers.upperFirstChar [
        "foo"
        " foo"
        "foo bar"
        "UPPER"
        "mIxEd"
      ];
      expected = [
        "Foo"
        " foo"
        "Foo bar"
        "UPPER"
        "MIxEd"
      ];
    };

    testGroupListBySize = {
      expr = {
        empty = helpers.groupListBySize 5 [ ];
        "5/5" = helpers.groupListBySize 5 (lib.genList lib.id 5);
        "13/5" = helpers.groupListBySize 5 (lib.genList lib.id 13);
      };
      expected = {
        empty = [ ];
        "5/5" = [
          [
            0
            1
            2
            3
            4
          ]
        ];
        "13/5" = [
          [
            0
            1
            2
            3
            4
          ]
          [
            5
            6
            7
            8
            9
          ]
          [
            10
            11
            12
          ]
        ];
      };
    };

    testEscapeStringForLua = {
      expr = lib.mapAttrs (_: helpers.utils.toLuaLongLiteral) {
        simple = "simple";
        depth-one = " ]] ";
        depth-two = " ]] ]=] ";
      };
      expected = {
        simple = "[[simple]]";
        depth-one = "[=[ ]] ]=]";
        depth-two = "[==[ ]] ]=] ]==]";
      };
    };

    testEscapeStringForVimscript = {
      expr = lib.mapAttrs (_: helpers.utils.toVimscriptHeredoc) {
        simple = "simple";
        depth-one = "EOF";
        depth-two = "EOF EOFF";
      };
      expected = {
        simple = ''
          << EOF
          simple
          EOF'';
        depth-one = ''
          << EOFF
          EOF
          EOFF'';
        depth-two = ''
          << EOFFF
          EOF EOFF
          EOFFF'';
      };
    };
  };
in
if results == [ ] then
  pkgs.runCommand "lib-tests-success" { } "touch $out"
else
  pkgs.runCommand "lib-tests-failure"
    {
      results = pkgs.lib.concatStringsSep "\n" (
        builtins.map (result: ''
          ${result.name}:
            expected: ${lib.generators.toPretty { } result.expected}
            result: ${lib.generators.toPretty { } result.result}
        '') results
      );
    }
    ''
      echo -e "Tests failed:\\n\\n$results" >&2
      exit 1
    ''
