//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-despite-the-name
//META: purpose=SV_GroupThreadID (per-thread local id) lowers to gl_LocalInvocationID with BuiltIn LocalInvocationId, distinct from SV_GroupIndex (a flat uint scalar).
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: legalizeEntryPointsForGLSL also rewrites
// SV_GroupThreadID (the three-component local id) — distinct from
// SV_GroupIndex (the flattened scalar) — into the gl_LocalInvocationID
// builtin variable.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 gtid : SV_GroupThreadID)
{
    outBuf[gtid.x] = gtid.x;
}

// CHECK: OpDecorate %gl_LocalInvocationID BuiltIn LocalInvocationId
