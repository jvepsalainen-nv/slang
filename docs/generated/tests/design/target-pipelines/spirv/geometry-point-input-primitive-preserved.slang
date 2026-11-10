//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-fragdepth-and-geometry-primitive-refinements
//META: purpose=A geometry entry point with an explicit point input primitive keeps InputPoints in the SPIR-V emit — the deferred triangle default-input-primitive fallback does not clash with a real primitive qualifier.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the geometry-shader default-input-primitive fallback
// (triangle), now applied only after all entry-point parameters are
// processed, does not override an explicit primitive qualifier. The
// entry point declares a `point` input; the CHECKs assert the SPIR-V
// execution mode is InputPoints (not the Triangles that the fallback
// default would produce).

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
void main(point GsIn pt[1], inout TriangleStream<GsOut> stream)
{
    GsOut v;
    v.pos = pt[0].pos;
    stream.Append(v);
    v.pos = pt[0].pos + float4(0.0, 1.0, 0.0, 0.0);
    stream.Append(v);
    v.pos = pt[0].pos + float4(1.0, 0.0, 0.0, 0.0);
    stream.Append(v);
    stream.RestartStrip();
}

// CHECK-DAG: OpCapability Geometry
// CHECK-DAG: OpEntryPoint Geometry
// CHECK-DAG: OpExecutionMode {{%[a-zA-Z_0-9]+}} InputPoints
// CHECK-DAG: OpExecutionMode {{%[a-zA-Z_0-9]+}} OutputTriangleStrip
