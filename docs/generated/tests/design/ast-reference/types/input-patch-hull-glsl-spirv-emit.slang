//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#geometry--and-tessellation-shader-io-types
//META: doc_section_digest=7c904d8992380b74b7c58a3b82c04f1512a6f31a7f5dec239acb5b75fe6f68d7
//META: purpose=An HLSLInputPatchType is the AST type for `InputPatch<T,N>`; the HLSL backend preserves the surface spelling at a hull-shader entry point.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the HLSLInputPatchType emission claim out to the GLSL and SPIR-V
// tessellation-control targets the sibling input-patch-hull.slang (HLSL)
// does not cover. At a hull entry point the patch lowers to a
// target-specific tessellation-control form: GLSL writes the
// `gl_TessLevelOuter` builtin and a per-control-point patch array,
// SPIR-V declares the Tessellation capability + `OpExecutionMode ...
// OutputVertices 3`. (Metal and WGSL have no hull stage; see Untested
// claims unsupported-on-target metal / wgsl.) Each CHECK pins the token
// that identifies the tessellation-control lowering, copied verbatim
// from slangc output.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage hull -entry hullMain
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage hull -entry hullMain

struct VSOutput
{
    float4 Pos : SV_POSITION;
};

struct HSOutput
{
    float4 Pos : SV_POSITION;
};

struct PatchConstants
{
    float Edges[3] : SV_TessFactor;
    float Inside : SV_InsideTessFactor;
};

PatchConstants ConstantsHS()
{
    PatchConstants pc;
    pc.Edges[0] = 1.0;
    pc.Edges[1] = 1.0;
    pc.Edges[2] = 1.0;
    pc.Inside = 1.0;
    return pc;
}

//GLSL: gl_TessLevelOuter
//SPV-DAG: OpCapability Tessellation
//SPV-DAG: OpExecutionMode %hullMain OutputVertices 3
[domain("tri")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(3)]
[patchconstantfunc("ConstantsHS")]
HSOutput hullMain(InputPatch<VSOutput, 3> patch, uint id : SV_OutputControlPointID)
{
    HSOutput o;
    o.Pos = patch[id].Pos;
    return o;
}
