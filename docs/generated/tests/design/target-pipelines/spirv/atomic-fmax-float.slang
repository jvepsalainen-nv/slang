//META: generated=true
//META: model=claude-opus-4-8-1m
//META: generated_at=2026-06-11T10:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: doc_section_digest=0621b76c92d5c66950f6bf752610276ae5f48c99c52c396b6035b11ef340daa4
//META: purpose=InterlockedMax on a float element lowers to OpAtomicFMaxEXT and pulls in the SPV_EXT_shader_atomic_float_min_max extension — the floating-point branch of the atomic-max op.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Depth: a float Max element selects the floating-point op
// OpAtomicFMaxEXT (vs the integer signed/unsigned S/UMax forms),
// gated by the SPV_EXT_shader_atomic_float_min_max extension. The
// CHECKs pin the op and the extension.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    InterlockedMax(outBuf[0], 5.0f);
}

// CHECK-DAG: OpExtension "SPV_EXT_shader_atomic_float_min_max"
// CHECK-DAG: OpAtomicFMaxEXT
