//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`StructuredBuffer::Load(0)` (lower-edge index) still surfaces `structuredBufferLoad(%buf, 0 : Int)`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: index 0 on the read-only structured-buffer path.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform StructuredBuffer<int> sbuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = sbuf.Load(0);
    rwbuf[tid.x] = v;
}

// IR-LABEL: func %main
// IR: structuredBufferLoad(%sbuf, 0 : Int)
