//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-despite-the-name
//META: purpose=SV_GroupIndex lowers to gl_LocalInvocationIndex with BuiltIn LocalInvocationIndex decoration in SPIR-V.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// legalizeEntryPointsForGLSL also rewrites SV_GroupIndex to the
// gl_LocalInvocationIndex input variable. This is the second
// canonical compute-stage system-value lowering.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(64, 1, 1)]
void main(uint gi : SV_GroupIndex, uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = gi;
}

// CHECK: OpDecorate %gl_LocalInvocationIndex BuiltIn LocalInvocationIndex
