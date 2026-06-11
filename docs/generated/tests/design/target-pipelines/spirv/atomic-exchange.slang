//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: doc_section_digest=0621b76c92d5c66950f6bf752610276ae5f48c99c52c396b6035b11ef340daa4
//META: purpose=InterlockedExchange on a uint lowers to OpAtomicExchange (unconditional swap), distinct from the compare-exchange CAS form.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the unconditional-swap member of the Interlocked atomic
// family. Exchange uses the IAtomicable interface (any atomicable
// type), unlike And/Or/Xor. The CHECK pins OpAtomicExchange to
// distinguish it from OpAtomicCompareExchange.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    uint orig;
    InterlockedExchange(outBuf[0], 7u, orig);
    outBuf[1] = orig;
}

// CHECK: OpAtomicExchange
