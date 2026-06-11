//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: doc_section_digest=0621b76c92d5c66950f6bf752610276ae5f48c99c52c396b6035b11ef340daa4
//META: purpose=InterlockedMin on a float element lowers to OpAtomicFMinEXT — the floating-point branch of the atomic-min op, distinct from integer S/UMin.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: a float Min element selects the floating-point op
// OpAtomicFMinEXT, distinct from the integer signed OpAtomicSMin and
// unsigned OpAtomicUMin. The CHECK pins the F-form.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    InterlockedMin(outBuf[0], 5.0f);
}

// CHECK: OpAtomicFMinEXT
