//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-fragdepth-and-geometry-primitive-refinements
//META: purpose=A geometry entry point that declares no input primitive qualifier falls back to the triangle default, emitting OpExecutionMode Triangles.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the default-input-primitive fallback that now runs at the end of
// entry-point legalization, after every parameter has been processed. The
// input vertex array carries no point / line / triangle qualifier, so the
// fallback must supply one; CHECK asserts the emitted execution mode is
// Triangles alongside the geometry capability, which is the companion case to
// the test that pins an explicitly qualified point input.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage geometry

struct GsIn
{
    float4 pos : SV_Position;
}

struct GsOut
{
    float4 pos : SV_Position;
}

[shader("geometry")]
[maxvertexcount(3)]
void main(GsIn verts[3], inout TriangleStream<GsOut> stream)
{
    GsOut v;
    v.pos = verts[0].pos;
    stream.Append(v);
}

// CHECK-DAG: OpCapability Geometry
// CHECK-DAG: OpExecutionMode %{{[a-zA-Z_0-9]+}} Triangles
