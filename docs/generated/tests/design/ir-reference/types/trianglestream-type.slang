//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A TriangleStream<T> geometry-shader output parameter surfaces the TriangleStream opcode parameterised by its element type in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A TriangleStream<T> geometry-shader output parameter surfaces the
// TriangleStream opcode parameterised by its element type in the IR
// dump. A geometry shader's `inout TriangleStream<RasterVertex>`
// parameter surfaces the `TriangleStream` opcode parameterised by its
// element-type struct in the IR dump.

//TEST:SIMPLE(filecheck=IR):-profile sm_5_0 -stage geometry -entry main -target hlsl -dump-ir -o -

// SV_Position cannot decorate an array directly; wrap each input vertex
// in a struct that carries the semantic.
struct GsInput
{
    float4 position : SV_Position;
}

struct RasterVertex
{
    float4 position : SV_Position;
}

[maxvertexcount(3)]
void main(triangle GsInput verts[3], inout TriangleStream<RasterVertex> outStream)
{
    RasterVertex v;
    v.position = verts[0].position;
    outStream.Append(v);
}

// IR-DAG: TriangleStream
