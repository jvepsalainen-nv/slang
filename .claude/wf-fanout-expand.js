export const meta = {
  name: 'emission-fanout-expand',
  description: 'Expand flagged emission claims to all shader text targets across the flagged bundles, following the new methodology prompts',
  phases: [{ title: 'Expand', detail: 'one expansion agent per flagged bundle' }],
}

// Worklist = bundle keys with emission fan-out gaps (passed via args, else this
// default captured from `regenerate.py lint` on the clean tree). target-pipelines/*
// is exempt by design and not listed.
const DEFAULT_WORKLIST = [
  'design/pipeline/06-emit',
  'conformance/basics-memory-model-address-spaces',
  'conformance/basics-memory-model-special-topics',
  'design/ast-reference/types',
  'conformance/basics-memory-model-consistency',
  'design/syntax-reference/keywords-and-builtins',
  'design/ast-reference/modifiers',
  'conformance/basics-execution-divergence-reconvergence',
  'conformance/types-interface',
  'conformance/statements',
  'conformance/generics',
  'conformance/expressions-identifier',
  'design/pipeline/overview',
  'design/ir-reference/values',
  'design/ir-reference/types',
  'design/cross-cutting/targets',
  'design/cross-cutting/serialization',
  'design/ast-reference/declarations',
  'conformance/types-pointer',
  'design/ast-reference/values',
  'design/ast-reference/expressions',
  'conformance/expressions-operator-precedence',
  'conformance/expressions-initializer',
  'conformance/declarations',
]

const WORKLIST = Array.isArray(args) && args.length ? args : DEFAULT_WORKLIST

const RESULT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    bundle: { type: 'string' },
    new_tests: { type: 'integer', description: 'new .slang files added' },
    targets_added: { type: 'string', description: 'e.g. "glsl x4, spirv-asm x6, metal x2"' },
    clean_emission: { type: 'integer' },
    negative_tests: { type: 'integer' },
    opt_outs: { type: 'integer', description: 'unsupported-on-target rows added' },
    findings: { type: 'integer', description: 'compiler-bug findings filed' },
    finding_ids: { type: 'array', items: { type: 'string' } },
    before_gaps: { type: 'integer' },
    after_gaps: { type: 'integer' },
    errors: { type: 'integer', description: 'lint errors for the bundle after the pass (must be 0)' },
    notes: { type: 'string' },
  },
  required: ['bundle', 'new_tests', 'before_gaps', 'after_gaps', 'errors'],
}

const PROMPT = (b) => `You are running a full EXPANSION pass on ONE generated-test bundle to close its emission/back-end coverage gaps. Follow the methodology prompts exactly — do not shortcut.

BUNDLE: \`docs/generated/tests/${b}\`
REPO ROOT: /home/jvepsalainen/workspace/jvepsalainen-nv/slang (branch 2026-06-emission-fanout-gate)
slangc: build/RelWithDebInfo/bin/slangc

READ FIRST, then follow as the authority for HOW to work:
- docs/generated/tests/_meta/prompts/_common.md (esp. Source-of-truth hierarchy)
- docs/generated/tests/_meta/prompts/_claims.md (esp. §2 "Meaningful back-ends" and "### Systematic variant expansion")
- docs/generated/tests/_meta/prompts/_expand.md (esp. step 6)
- the bundle's co-located _prompt.md, its README.md (its YAML front-matter names the source_doc — read that doc), and its existing *.slang.

TASK: Run \`python3 docs/generated/tests/_meta/regenerate.py lint ${b}\` to see the emission claims flagged as missing shader text targets {hlsl,glsl,spirv-asm,metal,wgsl}. Handle EVERY flagged emission claim in this bundle, bringing each to full shader-target coverage per the Systematic variant expansion rule:
- For each absent shader target, COMPILE the claim's shader to that target with slangc (match the form the existing sibling test uses for -entry/-stage) and CLASSIFY the ACTUAL result:
  - clean expected-shape output -> add an emission test pinning the CHECK to the REAL emitted text you observed (never invent CHECK lines; pin the distinguishing op/decoration tightly, leave %ids/registers wild e.g. %{{[0-9]+}});
  - clean rejection/diagnostic -> add a negative DIAGNOSTIC_TEST pinning the exact E####;
  - abort/crash/internal-error/malformed -> DO NOT write a passing test; file a finding under docs/generated/tests/_meta/findings/<slug>.yaml per _common.md and add an Untested row.
- If a target genuinely cannot express the claim, add a \`## Untested claims\` row with reason \`unsupported-on-target\` naming that target (bare target word, no backticks, in the Claim or Why cell). Never weaken a CHECK.
- Group by reusing the sibling claim's EXACT \`//META: purpose\` string (that verbatim string is the fan-out gate's grouping key). Stamp every new test \`//META: intent=expansion\` with the full //META block per _common.md (anchor doc_ref to the same claim as its sibling). Add the new files to the README \`## Functional coverage\` Tests column, and add \`## Doc gaps observed\` rows where the doc named a family generically without enumerating the per-target form.

HARD RULES: do NOT modify or delete existing tests; never assume output (run slangc, read what it emits); FileCheck is NOT installed locally so \`regenerate.py verify\` reports filecheck tests as "ignored" not "passed" — that's expected, rely on (a) each new .slang compiling cleanly under slangc and (b) CHECK lines copied verbatim from real output.

SUCCESS CHECK before finishing: every new .slang compiles cleanly (slangc exit 0); \`python3 docs/generated/tests/_meta/regenerate.py lint ${b}\` shows 0 emission fan-out warnings (or only justified opt-outs) and 0 errors.

Do NOT git commit. Return the structured result: bundle key, new_tests count, targets_added summary, how absent targets resolved (clean_emission / negative_tests / opt_outs / findings with finding_ids), before_gaps and after_gaps (fan-out warning counts from the lint command), lint errors (must be 0), and a one-line notes field.`

phase('Expand')
log(`Expanding ${WORKLIST.length} flagged bundles (one agent each, run-and-classify per shader target)`)
const results = await parallel(
  WORKLIST.map((b) => () =>
    agent(PROMPT(b), { label: `expand:${b}`, phase: 'Expand', schema: RESULT_SCHEMA })
  )
)

const ok = results.filter(Boolean)
const totalNew = ok.reduce((s, r) => s + (r.new_tests || 0), 0)
const totalFindings = ok.reduce((s, r) => s + (r.findings || 0), 0)
const totalOptouts = ok.reduce((s, r) => s + (r.opt_outs || 0), 0)
const stillOpen = ok.filter((r) => (r.after_gaps || 0) > 0)
const withErrors = ok.filter((r) => (r.errors || 0) > 0)
log(`Done: +${totalNew} tests across ${ok.length} bundles; ${totalOptouts} opt-outs; ${totalFindings} findings; ${stillOpen.length} bundles with residual gaps; ${withErrors.length} with lint errors`)
return { bundles: ok.length, totalNew, totalFindings, totalOptouts, results: ok }
