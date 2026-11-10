//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-despite-the-name
//META: purpose=SV_DispatchThreadID lowers to gl_GlobalInvocationID with BuiltIn GlobalInvocationId decoration in SPIR-V.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// legalizeEntryPointsForGLSL is reused by the SPIR-V direct-emit
// path (Phase C step 6). It rewrites the SV_DispatchThreadID
// system-value parameter as a gl_GlobalInvocationID input variable
// decorated BuiltIn GlobalInvocationId.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// CHECK: OpDecorate %gl_GlobalInvocationID BuiltIn GlobalInvocationId
