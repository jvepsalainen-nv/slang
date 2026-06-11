//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: doc_section_digest=0621b76c92d5c66950f6bf752610276ae5f48c99c52c396b6035b11ef340daa4
//META: purpose=InterlockedXor on an int lowers to OpAtomicXor, the bitwise-xor member of the atomic op family.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the bitwise-xor member of the Interlocked atomic family.
// One int cell suffices (bitwise op, no signedness split). The CHECK
// pins OpAtomicXor to distinguish it from And/Or.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    InterlockedXor(outBuf[0], 0x0F);
}

// CHECK: OpAtomicXor
