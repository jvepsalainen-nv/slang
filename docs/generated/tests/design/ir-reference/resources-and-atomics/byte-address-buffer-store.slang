//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`RWByteAddressBuffer::Store(offset, value)` surfaces the `byteAddressBufferStore(%buf, %offset, %alignment, %value)` opcode inside the pulled-in library function body.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `byteAddressBufferStore` parallels `byteAddressBufferLoad`. The
// opcode lives in the library `RWByteAddressBuffer.Store` body
// pulled into the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWByteAddressBuffer rwbabuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint idx = tid.x;
    rwbabuf.Store(idx * 4, idx + 7);
    rwbuf[idx] = idx;
}

// IR: byteAddressBufferStore({{.*}})
