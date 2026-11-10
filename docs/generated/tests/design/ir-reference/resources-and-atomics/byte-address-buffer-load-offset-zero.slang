//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`ByteAddressBuffer::Load(0)` (offset 0, lower edge) still surfaces the documented `byteAddressBufferLoad` opcode inside the pulled-in library helper body.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: byte offset 0, the lower edge.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform ByteAddressBuffer babuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint v = babuf.Load(0);
    rwbuf[tid.x] = v;
}

// IR: byteAddressBufferLoad(%{{[^,]+}}, {{.*}})
