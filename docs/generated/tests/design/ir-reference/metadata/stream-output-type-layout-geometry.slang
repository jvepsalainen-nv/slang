//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#layout-family
//META: purpose=A geometry entry point with an inout TriangleStream parameter produces a streamOutputTypeLayout whose operand 0 is the element type layout.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the geometry-stream layout record and its element operand. The
// stream's element is the `GsOut` struct, so following operand 0 of the
// emitted `streamOutputTypeLayout` must reach a `structTypeLayout`; that is
// what distinguishes the stored element layout from a bare attribute tail.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage geometry

struct GsIn
{
    float4 position : POSITION;
    float3 color    : COLOR;
};

struct GsOut
{
    float4 position : SV_Position;
    float3 color    : COLOR;
};

[shader("geometry")]
[maxvertexcount(3)]
void main(
    triangle GsIn input[3],
    inout TriangleStream<GsOut> stream)
{
    [ForceUnroll]
    for (int i = 0; i < 3; ++i)
    {
        GsOut v;
        v.position = input[i].position;
        v.color = input[i].color;
        stream.Append(v);
    }
}

// CHECK: = streamOutputTypeLayout(%[[ELEM:[0-9]+]]
// CHECK: %[[ELEM]]{{.*}}= structTypeLayout(
