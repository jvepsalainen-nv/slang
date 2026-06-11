//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#geometry--and-tessellation-shader-io-types
//META: doc_section_digest=7c904d8992380b74b7c58a3b82c04f1512a6f31a7f5dec239acb5b75fe6f68d7
//META: purpose=An HLSLPointStreamType is the AST type for the geometry-shader `PointStream<T>` output; the HLSL backend preserves the surface spelling and the stream's per-vertex method emits per the documented stream protocol.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the HLSLPointStreamType emission claim out to the GLSL and SPIR-V
// geometry targets the sibling point-stream-geometry.slang (HLSL) does
// not cover. At a geometry entry point the `PointStream<T>.Append(...)`
// lowers to a target-specific point emit: GLSL emits `EmitVertex()`,
// SPIR-V declares the Geometry capability + `OpExecutionMode ...
// OutputPoints`. (Metal and WGSL have no geometry stage; see Untested
// claims unsupported-on-target metal / wgsl.) Each CHECK pins the token
// that identifies the point-stream lowering, copied verbatim from
// slangc output.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage geometry -entry main -profile sm_5_0
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage geometry -entry main -profile sm_5_0

struct CoarseVertex
{
    float4 position : POSITION;
};

struct RasterVertex
{
    float4 position : POSITION;
};

//GLSL: EmitVertex();
//SPV-DAG: OpCapability Geometry
//SPV-DAG: OpExecutionMode %main OutputPoints
[maxvertexcount(1)]
void main(
    point CoarseVertex coarse[1],
    inout PointStream<RasterVertex> outputStream)
{
    RasterVertex v;
    v.position = coarse[0].position;
    outputStream.Append(v);
}
