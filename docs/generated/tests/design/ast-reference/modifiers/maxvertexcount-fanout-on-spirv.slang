//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:04:52Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#stage-specific-entry-point-attributes
//META: doc_section_digest=c70214a3d38c8f47b31dbc3940b51ba5fcdeb6d61435076d7a051fbb6e018f86
//META: purpose=`MaxVertexCountAttribute` (`[maxvertexcount(N)]`) on a geometry entry point appears in emitted HLSL with the documented count.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the `[maxvertexcount(N)]` claim onto SPIR-V. The attribute lowers
// to the `OutputVertices N` execution mode on the geometry entry point; CHECK
// pins `OpExecutionMode %main OutputVertices 3`, proving the documented count
// reaches the SPIR-V execution-mode declaration.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -profile sm_5_0 -stage geometry -entry main

struct GsIn { float4 pos : SV_Position; };
struct GsOut { float4 pos : SV_Position; };

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

//CHECK: OpExecutionMode %main OutputVertices 3
