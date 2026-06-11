//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#geometry--and-tessellation-shader-io-types
//META: doc_section_digest=7c904d8992380b74b7c58a3b82c04f1512a6f31a7f5dec239acb5b75fe6f68d7
//META: purpose=An HLSLTriangleStreamType is the AST type for the geometry-shader `TriangleStream<T>` output; the GLSL backend lowers it to per-vertex `EmitVertex()` invocations.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the HLSLTriangleStreamType emission claim out to the HLSL and
// SPIR-V geometry targets the sibling triangle-stream-geometry.slang
// (GLSL) does not cover. At a geometry entry point the
// `TriangleStream<T>` output lowers to a target-specific triangle-strip
// form: HLSL keeps the `TriangleStream<...>` surface spelling, SPIR-V
// declares the Geometry capability + `OpExecutionMode ...
// OutputTriangleStrip`. (Metal and WGSL have no geometry stage; see
// Untested claims unsupported-on-target metal / wgsl.) Each CHECK pins
// the token that identifies the triangle-stream lowering, copied
// verbatim from slangc output.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage geometry -entry main -profile sm_5_0
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage geometry -entry main -profile sm_5_0

struct CoarseVertex
{
    float4 position : POSITION;
};

struct RasterVertex
{
    float4 position : POSITION;
};

//HLSL: TriangleStream<RasterVertex
//SPV-DAG: OpCapability Geometry
//SPV-DAG: OpExecutionMode %main OutputTriangleStrip
[maxvertexcount(3)]
void main(
    triangle CoarseVertex coarse[3],
    inout TriangleStream<RasterVertex> outputStream)
{
    for (int i = 0; i < 3; ++i)
    {
        RasterVertex v;
        v.position = coarse[i].position;
        outputStream.Append(v);
    }
}
