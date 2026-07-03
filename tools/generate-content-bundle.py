#!/usr/bin/env python3
"""Regenerate js/workbench-content.js from content/.

The workbench embeds a snapshot of the content layer (taxonomy, registry,
year constants, admin mapping, base templates, carrier packs) so it runs
without a backend. Re-run this after ANY change under content/, then reload
the workbench and re-run the Corpus audit tab.
"""
import json
import glob
import os

ROOT = os.path.join(os.path.dirname(__file__), "..", "content")
OUT = os.path.join(os.path.dirname(__file__), "..", "js", "workbench-content.js")

content = {
    "taxonomy": json.load(open(f"{ROOT}/taxonomy.json")),
    "registry": json.load(open(f"{ROOT}/registry.json")),
    "yearConstants": json.load(open(f"{ROOT}/year-constants/2026.json")),
    "adminMapping": json.load(open(f"{ROOT}/admin-benefit-mapping.json")),
    "base": {},
    "carriers": {},
}
for f in glob.glob(f"{ROOT}/base/*.json"):
    t = json.load(open(f))
    content["base"][t["key"]] = t
for carrier_dir in glob.glob(f"{ROOT}/carriers/*/"):
    cname = os.path.basename(carrier_dir.rstrip("/"))
    content["carriers"][cname] = {}
    for f in glob.glob(carrier_dir + "*.json"):
        t = json.load(open(f))
        content["carriers"][cname][t["key"]] = t

with open(OUT, "w") as out:
    out.write("// GENERATED from content/ by tools/generate-content-bundle.py — do not edit by hand.\n")
    out.write("window.WB_CONTENT = ")
    json.dump(content, out, indent=1)
    out.write(";\n")

print(f"wrote {OUT}: {len(content['base'])} base templates, "
      f"carriers: {{{', '.join(f'{k}: {len(v)}' for k, v in content['carriers'].items())}}}")
