export const meta = {
  name: 'expand-variants',
  description: 'Doc-driven variant-depth expansion of under-covered bundles (_expand.md contract)',
  phases: [
    { title: 'Expand', detail: 'one agent per bundle: re-read source_doc, add variant-depth tests, verify' },
  ],
}

let _a = args
if (typeof _a === 'string') {
  try { _a = JSON.parse(_a) } catch (e) { _a = _a.split(/[,\s]+/).filter(Boolean) }
}
const BUNDLES = Array.isArray(_a) && _a.length ? _a : []
if (!BUNDLES.length) { log('No bundles passed via args; nothing to do.'); return { error: 'no bundles' } }

const REPORT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['bundle', 'files_created', 'tests_added', 'doc_gaps_added', 'verify', 'lint_clean', 'notes'],
  properties: {
    bundle: { type: 'string' },
    files_created: { type: 'array', items: { type: 'string' } },
    tests_added: { type: 'array', items: { type: 'string' }, description: '"claim -> variants added" entries' },
    doc_gaps_added: { type: 'array', items: { type: 'string' }, description: 'variants the code likely handles but the doc does not describe -> recorded as ## Doc gaps observed, NOT tested' },
    verify: {
      type: 'object', additionalProperties: false, required: ['passed', 'ignored', 'failed'],
      properties: { passed: { type: 'integer' }, ignored: { type: 'integer' }, failed: { type: 'integer' } },
    },
    lint_clean: { type: 'boolean' },
    notes: { type: 'string' },
  },
}

const PROMPT = (bundle) => `You are running the EXPANSION loop (_expand.md) on ONE under-covered test
bundle in the Slang repo. Work ONLY inside:
  docs/generated/tests/${bundle}/
NEVER edit files outside it (no _meta, no other bundles, no compiler source).
NEVER run git. Run commands from repo root
(/home/jvepsalainen/workspace/jvepsalainen-nv/slang).

WHY: a coverage measurement ranked this bundle as thin against its area.
Your job is to DEEPEN it — but under a hard contract.

THE HARD CONTRACT (docs/generated/tests/_meta/prompts/_expand.md): you get
NO source-line / coverage data. You must NOT write a test to chase a known
uncovered line — that would codify implementation instead of specification.
Author EVERY new test from the bundle's source_doc. If the doc does not
support a claim, you do not test it (you record a doc gap instead).

WHAT TO DO — re-read the source_doc (find its path in
docs/generated/tests/_meta/manifest.yaml under "${bundle}: source_doc:")
carefully and mine it for VARIANT DEPTH the existing tests miss
(see _claims.md §2 "Construct & legalization variants"):
  1. TABLES / ENUMERATIONS → one test per row. The doc's type->emit maps,
     opcode lists, decoration lists, per-element-type array strides, layout
     rules, storage-class maps: instantiate each documented entry that is
     not yet tested.
  2. "for each <type/shape/op>" RULES → one test per documented variant:
     numeric types (int8/16/32/64, uint*, half/float/double), shapes
     (scalar/vector/matrix), array vs struct elements, atomic ops
     (add/and/or/xor/min/max/exchange/compareExchange), address spaces.
  3. EXPLICIT DOC EXAMPLES not yet turned into a test.
  4. COROLLARIES of a documented rule -> a negative/boundary test.
  Stay BRANCH-DRIVEN, not Cartesian: add a variant only when the doc says
  the compiler treats it differently. Do not pad with combinations that
  collapse to the same emitted form.

HOW TO WRITE EACH NEW TEST:
  - Match the bundle's existing convention (file-per-claim/-target, or
    single-file multi-directive). Look at sibling files first.
  - Copy a sibling's //META block; change //META: purpose= to the specific
    variant and set //META: doc_ref= to the most specific doc anchor.
    Keep model=claude-opus-4-8 and a sibling's generated_at/source_commit.
    Add  //META: intent=expansion .
  - For emission claims: //TEST:SIMPLE(filecheck=NS):-target <T> <flags>,
    compile with build/RelWithDebInfo/bin/slangc, READ the real output, and
    pin 2-4 stable meaningful tokens. For functional: INTERPRET/COMPARE_COMPUTE
    -cpu with a printf/buffer value. NEVER invent CHECK text; NEVER weaken or
    edit an existing test.
  - A target/variant that does not compile or whose claim is not observable
    in output: do NOT add a passing-but-empty test; record it.

DOC GAPS: if you can see the bundle is thin because the code clearly handles
variants the DOC never describes, do NOT fabricate tests — add a row to the
bundle README "## Doc gaps observed" naming the missing-from-doc variant, and
report it in doc_gaps_added. That is the contract-correct outcome.

FINISH — both must be clean:
    python3 docs/generated/tests/_meta/regenerate.py verify ${bundle}
    python3 docs/generated/tests/_meta/regenerate.py lint ${bundle}
  verify FAILED:0; lint 0 errors (a size-cap WARNING is acceptable — do not
  delete good tests to satisfy it). Update the README ## Functional coverage
  rows to list the new variant tests. Iterate on YOUR additions until clean.

Return the structured report (final message MUST be the StructuredOutput call).`

phase('Expand')
const reports = await parallel(
  BUNDLES.map((b) => () =>
    agent(PROMPT(b), { label: `expand:${b.replace('design/', '')}`, phase: 'Expand', schema: REPORT_SCHEMA })
  )
)
const ok = reports.filter(Boolean)
const clean = ok.filter((r) => r.lint_clean && r.verify && r.verify.failed === 0)
log(`expand done: ${ok.length}/${BUNDLES.length} reports; ${clean.length} clean`)
return {
  total: BUNDLES.length,
  reported: ok.length,
  clean: clean.map((r) => r.bundle),
  needs_attention: ok.filter((r) => !(r.lint_clean && r.verify && r.verify.failed === 0)).map((r) => ({ bundle: r.bundle, verify: r.verify, lint_clean: r.lint_clean, notes: r.notes })),
  reports: ok,
}
