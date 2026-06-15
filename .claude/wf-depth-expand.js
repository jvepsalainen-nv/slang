export const meta = {
  name: 'emission-depth-expand',
  description: 'Deep per-type/per-op/per-shape emission-variant expansion on the residual emit/legalize hotspot bundles, following the systematic-expansion rule',
  phases: [{ title: 'Depth', detail: 'one depth agent per emission-heavy bundle' }],
}

// Emission/legalization hotspot bundles. target-pipelines/* are single-target by
// design (exempt from the breadth fan-out gate) but are exactly where per-type/op
// emission DEPTH lives. ir-reference/* emit to spirv-asm AND glsl (shared SPIR-V/
// GLSL legalize path = the biggest residual hotspots).
const DEFAULT_WORKLIST = [
  'design/target-pipelines/spirv',
  'design/target-pipelines/hlsl',
  'design/target-pipelines/metal',
  'design/target-pipelines/cuda',
  'design/target-pipelines/wgsl',
  'design/ir-reference/resources-and-atomics',
  'design/ir-reference/types',
  'design/ir-reference/values',
]
const WORKLIST = Array.isArray(args) && args.length ? args : DEFAULT_WORKLIST

const RESULT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    bundle: { type: 'string' },
    new_tests: { type: 'integer' },
    variant_families: { type: 'string', description: 'which variant grids were expanded, e.g. "atomics op-family x int/uint/int64; ArrayStride per element type"' },
    clean_emission: { type: 'integer' },
    negative_tests: { type: 'integer' },
    findings: { type: 'integer' },
    finding_ids: { type: 'array', items: { type: 'string' } },
    collapsed: { type: 'integer', description: 'candidate cells dropped because emission was identical to a kept cell' },
    errors: { type: 'integer', description: 'lint errors after the pass (must be 0)' },
    notes: { type: 'string' },
  },
  required: ['bundle', 'new_tests', 'errors'],
}

const PROMPT = (b) => `You are running a DEPTH expansion pass on ONE emission-heavy generated-test bundle. The goal is per-type / per-op / per-shape emission-variant DEPTH (not cross-target breadth). Follow the methodology prompts exactly.

BUNDLE: \`docs/generated/tests/${b}\`
REPO ROOT: /home/jvepsalainen/workspace/jvepsalainen-nv/slang (branch 2026-06-emission-fanout-gate)
slangc: build/RelWithDebInfo/bin/slangc

READ FIRST, then follow as the authority for HOW to work:
- docs/generated/tests/_meta/prompts/_common.md (esp. Source-of-truth hierarchy)
- docs/generated/tests/_meta/prompts/_claims.md — esp. the "Construct & legalization variants (depth)" dimension in §2 and the "### Systematic variant expansion" subsection (THE rule for this pass)
- docs/generated/tests/_meta/prompts/_expand.md (esp. step 6)
- the bundle's co-located _prompt.md, its README.md (read its source_doc), and its existing *.slang.

TASK — DEPTH, not breadth. For each emission claim in this bundle whose handling BRANCHES ON the input's type, shape, or op — a type-mapping/layout table, an opcode/decoration list, per-element-type array strides, a per-op atomic family, per-address-space storage classes, per-width numeric emission — instantiate ONE test per row/branch the surface enumerates, per the Systematic variant expansion rule:
- Enumerate the candidate variant grid from an AUTHORITATIVE surface: the language-reference type/intrinsic/operator tables, or the core-module declarations (*.meta.slang) for which intrinsic overloads/ops/types actually exist. (Core module = evidence for WHICH cells exist; never the doc_ref citation.)
- For each cell, COMPILE it with slangc to this bundle's emission target(s) and CLASSIFY the ACTUAL result:
  - clean expected-shape output -> add a test pinning the CHECK to the REAL emitted token that DISTINGUISHES this cell (e.g. \`OpAtomicAnd\` vs \`OpAtomicOr\`, \`ArrayStride 2\` vs \`ArrayStride 4\`, \`OpAtomicSMin\` vs \`OpAtomicUMin\`); leave incidental %ids/registers wild (%{{[0-9]+}}).
  - clean rejection/diagnostic -> negative DIAGNOSTIC_TEST pinning the exact E####.
  - abort/crash/internal-error/malformed -> file a finding under docs/generated/tests/_meta/findings/<slug>.yaml per _common.md; do NOT write a passing test.
- PRUNE collapses (branch-driven, not Cartesian): if two cells emit identical text (diff the real output), keep one representative and note the rest. Count how many you collapsed.
- Emission target(s): for a target-pipelines/<t> bundle, emit to that bundle's target <t> (it is single-target by design — go DEEP on it, do NOT fan to other targets). For an ir-reference bundle, emit to BOTH spirv-asm AND glsl (they share the SPIR-V/GLSL legalize path that holds the biggest residual coverage).
- Stamp every new test \`//META: intent=expansion\` with the full //META block; anchor doc_ref to the claim's section; reuse the sibling claim's exact \`//META: purpose\` only when it is the same claim, otherwise write a precise new purpose for the new variant. Add new files to the README \`## Functional coverage\` table and add \`## Doc gaps observed\` rows where the doc named a family/table generically without enumerating its rows.

HARD RULES: do NOT modify/delete existing tests; never assume output (run slangc, read it); FileCheck absent locally so verify reports filecheck tests "ignored" not "passed" — rely on (a) each new .slang compiling clean (slangc exit 0) and (b) CHECKs copied verbatim from real output.

SUCCESS CHECK: every new .slang compiles clean; \`python3 docs/generated/tests/_meta/regenerate.py lint ${b}\` shows 0 errors.

Do NOT git commit. Return the structured result: bundle, new_tests, variant_families summary, clean_emission/negative_tests/findings (with finding_ids), collapsed count, errors (must be 0), one-line notes.`

phase('Depth')
log(`Depth-expanding ${WORKLIST.length} emission-heavy bundles (per-type/op/shape variant grids, run-and-classify)`)
const results = await parallel(
  WORKLIST.map((b) => () =>
    agent(PROMPT(b), { label: `depth:${b}`, phase: 'Depth', schema: RESULT_SCHEMA })
  )
)
const ok = results.filter(Boolean)
const totalNew = ok.reduce((s, r) => s + (r.new_tests || 0), 0)
const totalFind = ok.reduce((s, r) => s + (r.findings || 0), 0)
const withErr = ok.filter((r) => (r.errors || 0) > 0)
log(`Depth done: +${totalNew} tests across ${ok.length} bundles; ${totalFind} findings; ${withErr.length} with lint errors`)
return { bundles: ok.length, totalNew, totalFind, results: ok }
