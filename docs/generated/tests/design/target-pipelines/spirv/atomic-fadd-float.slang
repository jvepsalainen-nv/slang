//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: doc_section_digest=0621b76c92d5c66950f6bf752610276ae5f48c99c52c396b6035b11ef340daa4
//META: purpose=InterlockedAdd on a float element lowers to OpAtomicFAddEXT and pulls in the AtomicFloat32AddEXT capability — the floating-point branch of the atomic-add op.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: the atomic-add op branches on element category. A float
// element selects the floating-point op OpAtomicFAddEXT (vs the
// integer OpAtomicIAdd), and requires the AtomicFloat32AddEXT
// capability. The CHECKs pin both the op and its capability.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    InterlockedAdd(outBuf[0], 1.0f);
}

// CHECK-DAG: OpCapability AtomicFloat32AddEXT
// CHECK-DAG: OpAtomicFAddEXT
