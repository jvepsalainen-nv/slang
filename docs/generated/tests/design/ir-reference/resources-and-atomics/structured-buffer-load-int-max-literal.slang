//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`StructuredBuffer::Load(INT_MAX)` (largest positive `int` literal) still surfaces the documented `structuredBufferLoad` opcode.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: max positive index literal on the read-only buffer.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform StructuredBuffer<int> sbuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = sbuf.Load(2147483647);
    rwbuf[tid.x] = v;
}

// IR-LABEL: func %main
// IR: structuredBufferLoad(%sbuf, 2147483647 : Int)
