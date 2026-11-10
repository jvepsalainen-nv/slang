//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`ByteAddressBuffer::Load(offset)` surfaces the `byteAddressBufferLoad(%buf, %offset, %alignment)` opcode inside the pulled-in library function body for `ByteAddressBuffer.Load`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a byte-address load reaches the IR as its own opcode
// carrying buffer, byte offset, and alignment. The CHECK is not
// anchored at `func %main`: the opcode is created inside the
// core-module `Load` body that the dump pulls in, and the user body
// holds only the call that specializes it.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform ByteAddressBuffer babuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint idx = tid.x;
    uint v = babuf.Load(idx * 4);
    rwbuf[idx] = v;
}

// IR: byteAddressBufferLoad(%{{[^,]+}}, %{{[^,]+}}, {{.*}})
