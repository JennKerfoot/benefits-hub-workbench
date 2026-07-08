# Pipeline — raw CMS → plan JSON

This is the translation engine that turns raw CMS PBP benefit filings into the
per-plan JSON consumed by the workbench (`../data/plans/*.json` and
`../data/plans_summary.json`). It is now co-versioned with the data it
generates: any change here should be accompanied by a regen and, where the
output changes, a commit of the updated `data/`.

This is the **canonical home** of the pipeline as of 2026-07-08. The prior
copy under `CMS-PBP-Translation-Package-2026/dashboard/` in the CMS Benefit
Data folder is now an archive (see `MOVED.md` there) — do not edit it.

## Raw CMS input

The raw PBP filings (`pbp_*.txt`, tab-delimited, plus dictionary files) are
**not committed** to this repo — the set is ~259MB. They live on disk at:

```
/Users/jennkerfoot/Documents/Claude Code/CMS Benefit Data/CMS-PBP-Translation-Package-2026/pbp-benefits-2026/
```

They're downloaded from CMS (Plan Benefit Package Landscape files). For the
file layout / column reference, see `PACKAGE_README` at the old location
(`CMS-PBP-Translation-Package-2026/`).

## Regenerating the data

```bash
python3 pipeline/preprocess.py
```

Run from the repo root. Takes a few minutes for all ~8,081 plans. Writes
`data/plans/{plan_id}.json`, `data/plans_summary.json`, `data/states.json`,
and `data/geo_index.json`.

### Overriding paths

Both the raw input dir and the output dir are configurable via env vars —
useful if the raw CMS folder lives somewhere else on your machine, or you
want to write output elsewhere for a dry run:

```bash
PBP_RAW_DIR=/path/to/pbp-benefits-2026 PBP_OUT_DIR=/tmp/out python3 pipeline/preprocess.py
```

Defaults: `PBP_RAW_DIR` points at the absolute path above; `PBP_OUT_DIR`
resolves to this repo's own `data/` (relative to the script file, so it works
regardless of your current working directory).

## Tests

```bash
python3 -m pytest pipeline/tests/ -v
```

42 tests covering benefit-limit extraction, reclaimed fields (hearing,
dental, vision, podiatry, chiropractic, cardiac rehab), §14c allowances, and
the v3-port helpers (model_test/SSBCI, combined benefits, transport).
`pipeline/tests/conftest.py` puts `pipeline/` on `sys.path` so the tests
import `preprocess` regardless of where pytest is invoked from.

## After a regen

Any time you regenerate `data/`, re-run the Corpus audit tab in the workbench
UI (`workbench.html`) to confirm the full 8,081-plan build is still clean,
then commit and push both the `data/` changes and the pipeline change
together.
