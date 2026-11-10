//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#option-set-toggles
//META: purpose=The non-essential-validation toggle gates D1 and D3-D9, so the missing-return warning disappears when validation is disabled while code generation still succeeds.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the gate on Phase D's validator block by compiling the same
// module twice. The default run must report the missing-return warning;
// the run with `-disable-non-essential-validations` must not report it at
// all, yet must still emit HLSL -- the positive CHECK on the emitted
// buffer declaration is what distinguishes "validation was skipped" from
// "compilation failed before reaching emit".

//TEST:SIMPLE(filecheck=WARN):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=NOWARN):-target hlsl -stage compute -entry main -disable-non-essential-validations

uniform int a;
uniform RWStructuredBuffer<int> buf;

int helper(int x) { if (x > 0) return 1; }

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = helper(a);
}

// WARN: warning{{.*}}41010

// NOWARN-NOT: 41010
// NOWARN: RWStructuredBuffer<int
