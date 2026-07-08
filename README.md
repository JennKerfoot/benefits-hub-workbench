# DUOS Benefits Hub — Carrier Onboarding Workbench

A **self-contained, browser-only reference implementation** of the Benefits Hub
card compiler ([docs/COMPILER_SPEC.md](docs/COMPILER_SPEC.md)). Everything is in
this repo: the app, the compiler, all 8,081 generated 2026 plan JSONs, the
content layer, the data-generating pipeline, and the docs. No backend, no
build step, no dependencies beyond Node (or any static file server) for the
app — the pipeline needs Python + pandas.

## Quickstart

```bash
node serve.js 8790
# open http://localhost:8790/workbench.html
```

Then: **pick a plan** (try `H7617_076` or `H5425_123`) → attach the SB/EOC →
edit the carrier pack → watch the compile update live. The **Corpus audit** tab
compiles every plan in ~25 seconds — run it after any change.

## What this is

The Benefits Hub shows members their plan benefits as cards. The architecture
in one sentence: **CMS/PBP data decides *whether* a benefit shows and every
number on screen; human-authored content decides *how we say it*; the compiler
merges them and refuses to ship anything PBP can't confirm.**

This workbench runs that compiler in the browser so engineering and content
teams can see exactly what any plan will compile to — before writing the
production version.

## The three inputs

### 1. Plan data (`data/plans/*.json`)
Generated from the raw CMS PBP filings by the pipeline now co-located in this
repo (`pipeline/preprocess.py` — see [pipeline/README.md](pipeline/README.md)).
Read-only input to the compiler — the source of truth for coverage and every
dollar amount. Regenerate in place after a CMS data refresh.

### 2. The content layer (`content/`)
Human-authored wording. Structure:

| Path | What it is |
|---|---|
| `content/taxonomy.json` | Which PBP benefit keys produce which member-facing cards (+ `pbpCategories` for wallet consolidation). The scalability keystone. |
| `content/registry.json` | CMS contract number → carrier pack (`H7617 → humana`). |
| `content/base/*.json` | Generic wording for all 23 card types — every plan renders with these even with no carrier pack. |
| `content/carriers/<name>/*.json` | **Carrier packs** — one small file per benefit the carrier promotes. |
| `content/admin-benefit-mapping.json` | Admin-tool benefit names → card keys (§4b). |
| `content/year-constants/2026.json` | Statutory amounts (Part D cap, insulin cap) for `source:"computed"` facts. |

**What a carrier pack is:** the wording layer for one carrier — vendor names
(TruHearing, SilverSneakers), vendor phones/URLs (become the card's CTA),
network names, how-to notes, and approved `eoc_facts` (the ONLY place a typed
dollar is allowed; each requires `approved:true` + a citation to the SB/EOC).
**What it cannot do:** create, remove, or re-price a benefit. A brand-new plan
renders correctly with zero new files.

After editing `content/`, regenerate the embedded snapshot:

```bash
python3 tools/generate-content-bundle.py
```

### 3. Admin-tool rows (pasted in the app, §4b)
The DUOS ops team maintains an internal admin tool with one free-text row per
covered benefit per plan — human-written "how to use this benefit"
instructions. Panel 4 ingests those rows (JSON array of
`{"plan_id","benefit_name","description_markdown"}`; admin IDs like
`H7617076000` crosswalk automatically). The blob renders as a "How to use this
benefit" box on the mapped card; phones/URLs become CTAs; free-text dollars and
misplaced SSBCI language are flagged; an unmapped benefit name fails the build;
and the PBP gate still rules — a row can never make an uncovered benefit appear.

## The pipeline (`pipeline/`)

The raw-CMS → plan-JSON translation engine now lives in this repo, co-versioned
with the `data/` it generates (moved 2026-07-08 from the standalone CMS
package). See [pipeline/README.md](pipeline/README.md) for how to regenerate,
the raw-input location (259MB, external, never committed), and the test suite
(42 tests, `python3 -m pytest pipeline/tests/ -v`).

## Compiler rules implemented

- **Gate on presence** — a card renders only if its PBP benefit keys exist.
- **Slot resolution** — `{fitness.copay}`-style slots filled from the plan
  JSON; `null` never renders as $0 (the row drops).
- **§4a shared-wallet consolidation (ONE wallet = ONE card)** — OTC + SSBCI
  items + VBID packages + Section D combined groups describing the same
  allowance render as a single wallet card; substance-free member cards are
  absorbed; substantive ones cross-reference; dental-max-style single-card
  allowances collapse onto their own card; naming ladder: carrier title →
  descriptive package name → group name → "Flex allowance".
- **Hard rules** — a literal dollar in content fails the build (rule 1, with
  the `eoc_facts`/`computed` carve-outs); `eoc_facts` need `approved:true` +
  citation (rule 2); unmapped admin benefit names fail the build (§4b).
- **Single-surface check** — every pooled amount appears on exactly one card;
  member-leaks are build-visible; same-amount coincidences are review notes.
- **EOC-vs-PBP discrepancy flags** — PBP wins; the conflicting EOC row is
  suppressed and reported.
- **D-SNP zero-dollar overlay** — display-only; filed values preserved.
- **Per-plan report** — cards rendered/gated/dropped, facts dropped, wallet
  consolidations, eoc_facts with citations, admin rows, content fallbacks.

## Corpus audit baseline (2026-07-03)

All 8,081 plans, ~23s: **8,081 builds passed · 0 hard-rule failures · 0
internal errors · 0 single-surface violations.** 3,236 wallet cards · 4,369
single-card allowance collapses · 3,907 absorbed cards · 1,317 VBID packages
merged · 743 D-SNP overlays. The only zero-card plans are the 19 MSAs + 2
employer PDPs that file no benefit detail.

## Repo map

```
workbench.html        the app (DUOS-branded UI shell)
js/workbench.js       compiler + UI logic (the reference implementation)
js/workbench-content.js  GENERATED content snapshot — regenerate via tools/
serve.js              minimal static server (node serve.js 8790)
data/                 plans_summary.json + 8,081 plan JSONs (pipeline output)
content/              the content layer (source of the generated snapshot)
docs/                 COMPILER_SPEC, architecture, plan-JSON reference,
                      content schema, card types, pipeline audit, plan QA
pipeline/             raw-CMS → plan-JSON translation engine + tests (see
                      pipeline/README.md)
tools/                content-bundle generator
```

## Provenance

- Plan data: CMS PBP Benefits 2026 landscape files → `pipeline/preprocess.py`
  (see [docs/PIPELINE_AUDIT_2026.md](docs/PIPELINE_AUDIT_2026.md) for the
  column-mapping audit, including Round 2).
- Faithfulness rule: the data is never hand-edited to match the EOC. EOC/SB
  content enters only through carrier packs and approved `eoc_facts`
  (see [docs/QA_H7617-076_VS_SB_EOC.md](docs/QA_H7617-076_VS_SB_EOC.md) for a
  worked example, verified 31/31 post-fix).
