//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: doc_section_digest=0621b76c92d5c66950f6bf752610276ae5f48c99c52c396b6035b11ef340daa4
//META: purpose=InterlockedMax on a uint lowers to OpAtomicUMax (unsigned variant), the unsigned counterpart of the signed OpAtomicSMax.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: completes the Min/Max signedness grid. The uint element of
// the Max op selects the unsigned SPIR-V op OpAtomicUMax. The CHECK
// pins the U-form to distinguish it from the signed OpAtomicSMax.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    InterlockedMax(outBuf[0], 5u);
}

// CHECK: OpAtomicUMax
