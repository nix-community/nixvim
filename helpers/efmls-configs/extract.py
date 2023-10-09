#!/usr/bin/env python

import sys
import os
import json

tool_path = sys.argv[1]

tools = {
    "linters": {},
    "formatters": {},
}

identity_langs = [
    "bash",
    "blade",
    "c",
    "clojure",
    "cmake",
    "crystal",
    "csh",
    "css",
    "d",
    "dart",
    "fish",
    "gitcommit",
    "go",
    "haskell",
    "html",
    "java",
    "javascript",
    "json",
    "jsonc",
    "ksh",
    "less",
    "lua",
    "make",
    "markdown",
    "nix",
    "pawn",
    "php",
    "proto",
    "python",
    "roslyn",
    "ruby",
    "rust",
    "sass",
    "scala",
    "scss",
    "sh",
    "slim",
    "sml",
    "solidity",
    "tex",
    "toml",
    "typescript",
    "vala",
    "vim",
    "yaml",
    "zsh",
    "misc",
]

lang_map = {
    "c#": "cs",
    "c++": "cpp",
    "docker": "dockerfile",
    "objective-c": "objc",
    "objective-c++": "objcpp",
    "terraform": "tf",
}

for lang in identity_langs:
    lang_map[lang] = lang

for kind in ["linters", "formatters"]:
    for file in os.listdir(tool_path + "/" + kind):
        tool_name = file.removesuffix(".lua")
        languages = []
        with open(tool_path + "/" + kind + "/" + file) as f:
            for line in f.readlines():
                if line.startswith("-- languages:"):
                    languages = [
                        lang_map[l.strip()]
                        for l in line.split(":")[1].strip().split(",")
                    ]
                    break
        tools[kind][tool_name] = languages

print(json.dumps(tools, indent=4, sort_keys=True))
