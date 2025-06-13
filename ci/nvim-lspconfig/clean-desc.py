#!/usr/bin/env python3

import json
import os
import subprocess
import sys

filter = os.environ.get("LUA_FILTER")
if filter is None:
    filter = os.path.dirname(__file__) + "/desc-filter.lua"

with open(sys.argv[1]) as f:
    data = json.load(f)
    for d in data:
        if "desc" in d:
            if "#" in d["desc"]:
                d["desc"] = subprocess.run(
                    ["pandoc", "-t", "markdown", f"--lua-filter={filter}"],
                    input=d["desc"],
                    capture_output=True,
                    text=True,
                ).stdout
    print(json.dumps(data, sort_keys=True))
