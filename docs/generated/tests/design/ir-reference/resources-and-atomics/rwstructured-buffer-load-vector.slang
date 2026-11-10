//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`rwbuf.Load(idx)` on a `RWStructuredBuffer<float4>` produces `rwstructuredBufferLoad(%buf, %idx)` with a vector result type, demonstrating the variadic-min-2 operand shape.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the load opcode's result type follows the buffer's
// element type without changing the opcode's operand shape. The element
// type here is a vector, and the CHECK still pins the two-operand
// `(buffer, index)` form under `func %main`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<float4> rwbuf;
uniform RWStructuredBuffer<float> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    float4 v = rwbuf.Load(idx);
    outbuf[idx] = v.x + v.y + v.z + v.w;
}

// IR-LABEL: func %main
// IR: rwstructuredBufferLoad(%rwbuf, %idx)
