export const meta = {
  name: 'backend-fanout',
  description: 'Augment target-general emission tests to cover every feasible text-emit backend',
  phases: [
    { title: 'Fan-out', detail: 'one agent per bundle: add missing-backend emission coverage + verify' },
  ],
}

// args = array of bundle keys, e.g. ["design/ast-reference/modifiers", ...]
let _a = args
if (typeof _a === 'string') {
  try { _a = JSON.parse(_a) } catch (e) { _a = _a.split(/[,\s]+/).filter(Boolean) }
}
const BUNDLES = Array.isArray(_a) && _a.length ? _a : []
if (!BUNDLES.length) {
  log('No bundles passed via args; nothing to do.')
  return { error: 'no bundles' }
}

const REPORT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['bundle', 'files_created', 'files_modified', 'targets_added', 'unsupported', 'verify', 'lint_clean', 'findings', 'notes'],
  properties: {
    bundle: { type: 'string' },
    files_created: { type: 'array', items: { type: 'string' } },
    files_modified: { type: 'array', items: { type: 'string' } },
    targets_added: { type: 'array', items: { type: 'string' }, description: 'human-readable "claim -> targets added" entries' },
    unsupported: { type: 'array', items: { type: 'string' }, description: '"claim -> target (reason)" for targets that did not compile' },
    verify: {
      type: 'object', additionalProperties: false,
      required: ['passed', 'ignored', 'failed'],
      properties: { passed: { type: 'integer' }, ignored: { type: 'integer' }, failed: { type: 'integer' } },
    },
    lint_clean: { type: 'boolean' },
    findings: { type: 'array', items: { type: 'string' }, description: 'compiler bugs/crashes discovered (target + symptom); not filed' },
    notes: { type: 'string' },
  },
}

const PROMPT = (bundle) => `You are augmenting ONE test bundle in the Slang repo to satisfy the suite's
mandatory backend fan-out rule. Work ONLY inside this bundle directory:
  docs/generated/tests/${bundle}/
NEVER edit files outside that directory (no _meta, no other bundles, no
compiler source). NEVER run git. Run all commands from the repo root
(/home/jvepsalainen/workspace/jvepsalainen-nv/slang).

THE RULE (docs/generated/tests/_meta/prompts/_claims.md §2 "Meaningful
back-ends"): a TARGET-GENERAL emission claim must be exercised on EVERY
FEASIBLE text-emit target: hlsl, glsl, spirv-asm, metal, wgsl, cuda, cpp —
not just the one the doc names.

STEP 1 — find the emission tests in this bundle.
  - Emission tests are .slang files with a directive like
    //TEST:SIMPLE(filecheck=...):-target <T> ...
  - EXCLUDE from fan-out (leave untouched):
      * directives containing -dump-ir  (IR inspection = target-independent)
      * //TEST:INTERPRET and //TEST:COMPARE_COMPUTE  (functional)
      * claims that are inherently TARGET-SPECIFIC — the //META purpose or
        filename ties the behavior to one target (e.g. an HLSL-only
        attribute, a SPIR-V-only legalization). Use judgment; if the claim
        is "X appears in emitted HLSL" but X is a general language feature
        (numthreads, groupshared, a cast, an operator), it is target-GENERAL.

STEP 2 — group by claim. A claim may ALREADY be fanned out across sibling
  files (e.g. numthreads-emits-on-hlsl.slang AND numthreads-emits-on-glsl.slang).
  Read the bundle README and the //META purpose lines to group files by claim.
  Note the bundle's CONVENTION: file-per-target (one .slang per target, named
  <claim>-...-on-<target>.slang) OR single-file-multi-directive (multiple
  //TEST directives with distinct filecheck namespaces in one file). MATCH it.

STEP 3 — for each target-general emission claim, determine feasible targets.
  For each target T in {hlsl, glsl, spirv-asm, metal, wgsl, cuda, cpp} not yet
  covered by any sibling, compile the claim's shader:
    build/RelWithDebInfo/bin/slangc <file> -target T <same -entry/-stage/other flags as the existing directive>
  Feasible = exit code 0 AND non-empty output. (spirv-asm is the spirv text form.)

STEP 4 — add coverage for each feasible, not-yet-covered target.
  * file-per-target bundle: create <claim>-...-on-<T>.slang. Copy the //META
    block VERBATIM from an existing sibling, then change ONLY //META: purpose=
    to name target T. Keep doc_ref and doc_section_digest IDENTICAL to the
    sibling (same doc section). Keep model=claude-opus-4-8 and the sibling's
    generated_at / source_commit. Reuse the sibling's shader body. Add
    //TEST:SIMPLE(filecheck=CHECK):-target T <flags>.
  * multi-directive bundle: add //TEST:SIMPLE(filecheck=<NS>):-target T <flags>
    to the existing file with a distinct UPPERCASE namespace (GLSL/METAL/WGSL/
    HLSL/CUDA/CPP/SPIRV) and // <NS>: check lines.
  CHECK lines: run slangc, READ the actual output, and pin 2-4 STABLE,
  meaningful tokens that show the claim on that target (entry-point name, the
  emitted construct the claim is about, the target-specific spelling — e.g.
  @workgroup_size for wgsl, layout(local_size_x=...) for glsl,
  [[...]]/threads for metal). Use CHECK-DAG when order may vary. NEVER invent
  CHECK text. NEVER weaken or remove an existing CHECK.

STEP 5 — targets that DON'T compile are unsupported: do NOT add a test; add an
  "unsupported-on-target" row to the bundle README's "## Untested claims"
  naming the claim and target. If a target COMPILES but you cannot author a
  clean passing CHECK, or it crashes the compiler, SKIP that target, note it in
  findings, and remove any partial addition — never leave a failing test.

STEP 6 — verify and lint THIS bundle (must both be clean):
    python3 docs/generated/tests/_meta/regenerate.py verify ${bundle}
    python3 docs/generated/tests/_meta/regenerate.py lint ${bundle}
  verify must show FAILED: 0 (new tests pass). lint must show 0 errors.
  Iterate on YOUR additions until clean. Update the README Functional-coverage
  'backends' dimension to reflect the targets you added.

Then return the structured report (your final message MUST be the
StructuredOutput tool call — it is data, not prose).`

phase('Fan-out')
const reports = await parallel(
  BUNDLES.map((b) => () =>
    agent(PROMPT(b), { label: `fanout:${b.replace('design/', '')}`, phase: 'Fan-out', schema: REPORT_SCHEMA })
  )
)

const ok = reports.filter(Boolean)
const clean = ok.filter((r) => r.lint_clean && r.verify && r.verify.failed === 0)
const dirty = ok.filter((r) => !(r.lint_clean && r.verify && r.verify.failed === 0))
log(`fan-out done: ${ok.length}/${BUNDLES.length} reports; ${clean.length} clean, ${dirty.length} need attention`)
return {
  total: BUNDLES.length,
  reported: ok.length,
  clean: clean.map((r) => r.bundle),
  needs_attention: dirty.map((r) => ({ bundle: r.bundle, verify: r.verify, lint_clean: r.lint_clean, notes: r.notes })),
  reports: ok,
}
