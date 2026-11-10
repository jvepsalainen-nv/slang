//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#byteaddressbufferstore-operand-naming
//META: purpose=`byteAddressBufferStore` carries four operands in the order `buffer, offset, alignment, value` — the alignment literal sits at operand 2 and the stored value at operand 3, the reverse of the Lua operand names.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the real operand order behind the swapped accessor names. The
// stored value is derived from `SV_DispatchThreadID` while the alignment
// the builder inserts is a literal, so the two are distinguishable in
// the dump: the CHECK requires a bare integer literal in the third
// position and a named SSA value in the fourth. Matching is global
// because the opcode is created inside the library `Store` body.

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

// IR: byteAddressBufferStore(%{{[A-Za-z0-9_]+}}, %{{[A-Za-z0-9_]+}}, {{[0-9]+}} : UInt, %{{[A-Za-z0-9_]+}})
