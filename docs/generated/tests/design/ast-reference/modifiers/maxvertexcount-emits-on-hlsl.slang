//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[maxvertexcount(N)]` on a geometry entry point appears in emitted HLSL with the documented count.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the attribute's integer argument is retained and reproduced on the
// emitted geometry entry point, which downstream compilers require in order to
// size the output stream. CHECK asserts the emitted HLSL names the same count
// the source wrote.

// The Khronos back ends carry the same bound as stage state rather than as an
// attribute: GLSL emits `layout(max_vertices = 3) out` and SPIR-V the
// `OutputVertices 3` execution mode, so each prefix asserts the count itself
// travelled, not merely that a geometry entry point was produced.

//TEST:SIMPLE(filecheck=CHECK): -target hlsl -profile sm_5_0 -stage geometry -entry main
//TEST:SIMPLE(filecheck=GLSL): -target glsl -stage geometry -entry main
//TEST:SIMPLE(filecheck=SPIRV): -target spirv-asm -stage geometry -entry main

struct GsIn
{
    float4 pos : SV_Position;
};

struct GsOut
{
    float4 pos : SV_Position;
};

[maxvertexcount(3)]
void main(triangle GsIn input[3], inout TriangleStream<GsOut> outStream)
{
    for (int i = 0; i < 3; ++i)
    {
        GsOut o;
        o.pos = input[i].pos;
        outStream.Append(o);
    }
}

//CHECK: maxvertexcount(3)

//GLSL: layout(max_vertices = 3) out;
//SPIRV: OpExecutionMode %{{[A-Za-z0-9_]+}} OutputVertices 3
