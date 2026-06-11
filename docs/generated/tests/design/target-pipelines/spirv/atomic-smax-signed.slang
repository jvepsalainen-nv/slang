//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: doc_section_digest=0621b76c92d5c66950f6bf752610276ae5f48c99c52c396b6035b11ef340daa4
//META: purpose=InterlockedMax on a signed int lowers to OpAtomicSMax (signed variant), distinct from the unsigned OpAtomicUMax emitted for uint.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the atomic Max op branches on element signedness. A signed
// `int` element selects OpAtomicSMax. The CHECK pins the S-form to
// distinguish the signed branch from the U-form used for uint.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    InterlockedMax(outBuf[0], 5);
}

// CHECK: OpAtomicSMax
