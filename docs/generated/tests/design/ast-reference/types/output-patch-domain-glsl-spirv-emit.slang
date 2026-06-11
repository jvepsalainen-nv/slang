//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#geometry--and-tessellation-shader-io-types
//META: doc_section_digest=7c904d8992380b74b7c58a3b82c04f1512a6f31a7f5dec239acb5b75fe6f68d7
//META: purpose=An HLSLOutputPatchType is the AST type for `OutputPatch<T,N>`; the HLSL backend preserves the surface spelling at a domain-shader entry point.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the HLSLOutputPatchType emission claim out to the GLSL and SPIR-V
// tessellation-evaluation targets the sibling output-patch-domain.slang
// (HLSL) does not cover. At a domain entry point the patch lowers to a
// target-specific tessellation-evaluation form: GLSL reads the
// `gl_TessCoord` builtin, SPIR-V declares the Tessellation capability +
// a `TessellationEvaluation` entry point. (Metal and WGSL have no domain
// stage; see Untested claims unsupported-on-target metal / wgsl.) Each
// CHECK pins the token that identifies the tessellation-evaluation
// lowering, copied verbatim from slangc output.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage domain -entry domainMain
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage domain -entry domainMain

struct HSOutput
{
    float4 Pos : SV_POSITION;
};

struct DSOutput
{
    float4 Pos : SV_POSITION;
};

struct PatchConstants
{
    float Edges[3] : SV_TessFactor;
    float Inside : SV_InsideTessFactor;
};

//GLSL: gl_TessCoord
//SPV-DAG: OpCapability Tessellation
//SPV-DAG: OpEntryPoint TessellationEvaluation %domainMain
[domain("tri")]
DSOutput domainMain(
    PatchConstants pc,
    float3 bary : SV_DomainLocation,
    const OutputPatch<HSOutput, 3> patch)
{
    DSOutput o;
    o.Pos = bary.x * patch[0].Pos
          + bary.y * patch[1].Pos
          + bary.z * patch[2].Pos;
    return o;
}
