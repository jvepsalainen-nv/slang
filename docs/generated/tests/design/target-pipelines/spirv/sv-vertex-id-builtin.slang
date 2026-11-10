//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-despite-the-name
//META: purpose=SV_VertexID lowers to gl_VertexIndex with BuiltIn VertexIndex (Vulkan-style index, not D3D-style ID, hence the rename).
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: vertex-stage builtin. legalizeEntryPointsForGLSL maps
// HLSL SV_VertexID to gl_VertexIndex (Vulkan's index semantic, which
// includes the base-vertex offset). The decoration is "VertexIndex".

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage vertex

RWStructuredBuffer<uint> outBuf;

[shader("vertex")]
float4 main(uint vid : SV_VertexID) : SV_Position
{
    outBuf[vid] = vid;
    return float4(0, 0, 0, 1);
}

// CHECK: OpDecorate %gl_VertexIndex BuiltIn VertexIndex
