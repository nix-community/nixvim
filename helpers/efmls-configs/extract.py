#!/usr/bin/env python

import sys
import os
import json

tool_path = sys.argv[1]

tools = {
    "linters": {},
    "formatters": {},
}

for kind in ["linters", "formatters"]:
    for file in os.listdir(tool_path + "/" + kind):
        tool_name = file.removesuffix(".lua")
        languages = []
        with open(tool_path + "/" + kind + "/" + file) as f:
            for line in f.readlines():
                if line.startswith("-- languages:"):
                    languages = line.split(":")[1].strip().split(",")
                    break
        tools[kind][tool_name] = languages

print(json.dumps(tools, indent=4))
