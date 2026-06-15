export const meta = {
  name: 'expand-deep',
  description: 'Exhaustive depth-first emission-variant expansion of the highest-residual bundles',
  phases: [
    { title: 'Deepen', detail: 'one agent per bundle: exhaustively instantiate doc-enumerable emission variants' },
  ],
}

let _a = args
if (typeof _a === 'string') {
  try { _a = JSON.parse(_a) } catch (e) { _a = _a.split(/[,\s]+/).filter(Boolean) }
}
const BUNDLES = Array.isArray(_a) && _a.length ? _a : []
if (!BUNDLES.length) { log('No bundles passed via args; nothing to do.'); return { error: 'no bundles' } }

const REPORT_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['bundle', 'files_created', 'tests_added', 'doc_gaps_added', 'verify', 'lint_clean', 'notes'],
  properties: {
    bundle: { type: 'string' },
    files_created: { type: 'array', items: { type: 'string' } },
    tests_added: { type: 'array', items: { type: 'string' } },
    doc_gaps_added: { type: 'array', items: { type: 'string' }, description: 'enumerable variants the code handles but the doc does not describe -> recorded for the doc-enrichment backlog, NOT tested' },
    verify: { type: 'object', additionalProperties: false, required: ['passed', 'ignored', 'failed'],
      properties: { passed: { type: 'integer' }, ignored: { type: 'integer' }, failed: { type: 'integer' } } },
    lint_clean: { type: 'boolean' },
    notes: { type: 'string' },
  },
}

const PROMPT = (bundle) => `You are running a DEEP expansion pass on ONE under-covered emission/IR-pass
test bundle. Work ONLY inside docs/generated/tests/${bundle}/ . NEVER edit
files outside it, NEVER run git, run commands from repo root
(/home/jvepsalainen/workspace/jvepsalainen-nv/slang). slangc =
build/RelWithDebInfo/bin/slangc.

This is the DEEPEST tier: be EXHAUSTIVE, not conservative. A prior breadth
pass already added a few variants; your job is to instantiate EVERY
documented enumerable variant that is not yet covered.

HARD CONTRACT (docs/generated/tests/_meta/prompts/_expand.md): author from
the bundle's source_doc, NEVER from coverage/source-line data (you get none).
Every test maps to a documented claim. Find the doc via
docs/generated/tests/_meta/manifest.yaml ("${bundle}: source_doc:").

EXHAUSTIVE VARIANT EXPANSION (_claims.md §2 depth rule). Where the doc states
a rule over a family, instantiate EVERY member the compiler treats differently
(branch-driven, not Cartesian — skip variants that collapse to the same
emitted form):
  - per element/operand TYPE: int8/int16/int(32)/int64, uint8/16/32/64, half,
    float, double, bool — wherever the doc's rule is type-parametric (buffer
    element layout / array stride, numeric emit, atomics operand).
  - per SHAPE: scalar, vector2/3/4, matrix (square + non-square), array,
    struct, nested struct — wherever the doc's rule is shape-parametric.
  - per OP: for an atomics/interlocked claim, each op the doc names
    (add/and/or/xor/min/max/exchange/compareExchange); for a layout claim,
    each documented layout/stride rule.
  - per RESOURCE/STORAGE: StructuredBuffer vs RWStructuredBuffer vs
    ByteAddressBuffer vs ConstantBuffer; groupshared vs device; where named.

EMIT BROADLY for each variant. The largest uncovered backends are SPIR-V emit
and the SHARED SPIR-V/GLSL legalization path (the doc notes
legalizeEntryPointsForGLSL runs on the SPIR-V arm). So for every emission
variant you add, include BOTH a \`-target spirv-asm\` and a \`-target glsl\`
directive (distinct filecheck namespaces) when the construct is observable on
each, plus the bundle's own primary target. Compile each with slangc, READ the
real output, pin 2-4 stable tokens per target. NEVER invent or weaken a CHECK.

HOW: match the bundle convention; new file per variant (or per-target
directives in one file). Copy a sibling //META block, set purpose= to the
variant + doc_ref= to the most specific anchor, add //META: intent=expansion,
keep model=claude-opus-4-8. A variant that does not compile or is not
observable in output -> do NOT add an empty test; skip it.

DOC GAPS: if the code clearly handles an enumerable variant the doc never
describes, do NOT fabricate a test — add a "## Doc gaps observed" row naming
the missing-from-doc variant and report it in doc_gaps_added. This backlog is
a primary deliverable of this pass.

FINISH (both clean): run
  python3 docs/generated/tests/_meta/regenerate.py verify ${bundle}
  python3 docs/generated/tests/_meta/regenerate.py lint ${bundle}
verify FAILED:0; lint 0 errors (size-cap WARNING ok — never delete good tests
for it). Update README ## Functional coverage rows. Iterate until clean.
Return the structured report (final message MUST be the StructuredOutput call).`

phase('Deepen')
const reports = await parallel(
  BUNDLES.map((b) => () =>
    agent(PROMPT(b), { label: `deep:${b.replace('design/', '')}`, phase: 'Deepen', schema: REPORT_SCHEMA })
  )
)
const ok = reports.filter(Boolean)
const clean = ok.filter((r) => r.lint_clean && r.verify && r.verify.failed === 0)
log(`deep expand done: ${ok.length}/${BUNDLES.length} reports; ${clean.length} clean`)
return {
  total: BUNDLES.length, reported: ok.length,
  clean: clean.map((r) => r.bundle),
  needs_attention: ok.filter((r) => !(r.lint_clean && r.verify && r.verify.failed === 0)).map((r) => ({ bundle: r.bundle, verify: r.verify, lint_clean: r.lint_clean, notes: r.notes })),
  reports: ok,
}
