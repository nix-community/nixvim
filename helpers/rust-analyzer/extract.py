#!/usr/bin/env python3

import sys
import json

ra_package_json = sys.argv[1]
with open(ra_package_json) as f:
    ra_package = json.load(f)

config = ra_package["contributes"]["configuration"]["properties"]

config_dict = {}

in_common_block = False


def py_to_nix(obj):
    if obj is None:
        return "null"

    if obj is False:
        return "false"

    if obj is True:
        return "true"

    if isinstance(obj, str):
        s = f'"{obj}"'
        if "${" in s:
            s = s.replace("${", "$\\{")
        return s

    if isinstance(obj, int):
        return f"{obj}"

    if isinstance(obj, dict):
        val = "{"
        for key in obj:
            key_val = py_to_nix(obj[key])
            val += f'"{key}" = {key_val};\n'
        val += "}"

        return val

    if isinstance(obj, list):
        return "[" + " ".join(py_to_nix(val) for val in obj) + "]"

    print(f"Unhandled value: {obj}")
    sys.exit(1)


def ty_to_nix(ty):
    if ty == "boolean":
        return "types.bool"

    if ty == "string":
        return "types.str"

    # This is an object without any additional properties
    if ty == "object":
        return "types.attrsOf types.anything"

    if isinstance(ty, list) and ty[0] == "null":
        if len(ty) > 2:
            print("Unhandled type", ty)
            sys.exit()

        nullable_ty = ty_to_nix(ty[1])
        return f"types.nullOr ({nullable_ty})"

    if isinstance(ty, list):
        either_types = (ty_to_nix(t) for t in ty)
        either_types = " ".join(f"({t})" for t in either_types)
        return f"types.oneOf ([{either_types}])"

    print(f"Unhandled type: {ty}")
    sys.exit(1)


def prop_ty_to_nix(prop_info):
    if "type" in prop_info:
        if "enum" in prop_info:
            enum = "[" + " ".join(f'"{member}"' for member in prop_info["enum"]) + "]"
            if prop_info["type"] == "string":
                return f"types.enum {enum}"

            print("TODO: with unknown enum type", prop_info["type"])
            sys.exit()

        if "additionalProperties" in prop_info or "properties" in prop_info:
            print("TODO: with (additional)Properties", prop_info)
            sys.exit()

        if "minimum" in prop_info or "maximum" in prop_info:
            can_be_null = False
            if "null" in prop_info["type"]:
                can_be_null = True
                if len(prop_info["type"]) > 2:
                    print("Unhandled int type", prop_info["type"])
                    sys.exit()
                prop_info["type"] = prop_info["type"][1]

            if prop_info["type"] == "number":
                int_ty = "types.number"
            elif prop_info["type"] == "integer":
                int_ty = "types.int"
            else:
                print("Unhandled int type", prop_info["type"])
                sys.exit()

            if "minimum" in prop_info and "maximum" in prop_info:
                min = prop_info["minimum"]
                max = prop_info["maximum"]
                int_ty = f"{int_ty}s.between {min} {max}"
            elif "minimum" in prop_info:
                min = prop_info["minimum"]
                int_ty = f"types.addCheck {int_ty} (x: x >= {min})"
            else:
                print("TODO: max number", prop_info)
                sys.exit()

            if can_be_null:
                return f"types.nullOr ({int_ty})"
            else:
                return int_ty

        if "array" in prop_info["type"] or prop_info["type"] == "array":
            if "items" not in prop_info:
                print("Array without items")
                sys.exit()

            items_ty = prop_ty_to_nix(prop_info["items"])
            array_ty = f"types.listOf ({items_ty})"
            if prop_info["type"] == "array":
                return array_ty
            elif prop_info["type"] == ["null", "array"]:
                return f"types.nullOr ({array_ty})"
            else:
                print("Unhandled array type", prop_info)
                sys.exit()

        return ty_to_nix(prop_info["type"])
    elif "anyOf" in prop_info:
        can_be_null = False
        if {"type": "null"} in prop_info["anyOf"]:
            can_be_null = True
            prop_info["anyOf"].remove({"type": "null"})

        types = (prop_ty_to_nix(prop) for prop in prop_info["anyOf"])
        one_of = " ".join(f"({ty})" for ty in types)
        one_of_ty = f"types.oneOf ([{one_of}])"

        if can_be_null:
            return f"types.nullOr ({one_of_ty})"
        else:
            return one_of_ty
    else:
        print("TODO: no *type*", prop_info)
        sys.exit()


for opt in config:
    if opt.startswith("$"):
        in_common_block = True
        continue

    if not in_common_block:
        continue

    opt_path = opt.split(".")
    if opt_path[0] != "rust-analyzer":
        print("ERROR: expected all options to start with 'rust-analyzer'")
        sys.exit(1)

    path = opt_path[1:-1]
    option = opt_path[-1]

    top_dict = config_dict

    for p in path:
        if not p in top_dict:
            top_dict[p] = {}
        top_dict = top_dict[p]

    prop_info = config[opt]

    is_optional = False

    ty = prop_ty_to_nix(prop_info)

    default = py_to_nix(prop_info["default"])

    if "markdownDescription" in prop_info:
        desc = prop_info["markdownDescription"]
    else:
        desc = prop_info["description"]

    desc += f"\n\ndefault value is: \n```nix\n    {default}\n```"

    top_dict[
        option
    ] = """
mkOption {{
type = types.nullOr ({ty});
default = null;
description = ''
{desc}
'';
}}
    """.format(
        ty=ty, default=default, desc=desc
    )


def print_dict(d):
    print("{")
    for key in d:
        print(f'"{key}" = ')
        if isinstance(d[key], str):
            print(d[key])
        else:
            print_dict(d[key])
        print(";")
    print("}")


print("# THIS FILE IS AUTOGENERATED DO NOT EDIT")
print("lib: with lib;")
print_dict(config_dict)
