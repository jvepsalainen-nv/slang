//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A LineStream<T> geometry-shader output parameter surfaces the LineStream opcode parameterised by its element type in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A LineStream<T> geometry-shader output parameter surfaces the
// LineStream opcode parameterised by its element type in the IR dump.
// A geometry shader's `inout LineStream<RasterVertex>` parameter
// surfaces the `LineStream` opcode parameterised by its element type
// in the IR dump.

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

[maxvertexcount(2)]
void main(line GsInput verts[2], inout LineStream<RasterVertex> outStream)
{
    RasterVertex v;
    v.position = verts[0].position;
    outStream.Append(v);
}

// IR-DAG: LineStream
