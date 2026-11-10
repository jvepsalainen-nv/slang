//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<T>` on a `groupshared` array element also lowers to `atomicAdd`, demonstrating that the atomic opcode is independent of the underlying address-space backing the `Atomic<T>` element.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The atomic-operations doc states the pointer operand is "a
// pointer to the target location"; the address-space behind that
// pointer can be either a buffer element or a `groupshared`
// variable. The opcode is the same, including the single trailing
// memory-order operand of the documented `ptr, val, memoryOrder`
// shape.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

groupshared Atomic<int> gsa;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, uint3 gid : SV_GroupThreadID)
{
    int prev = gsa.add((int)gid.x + 1);
    rwbuf[tid.x] = prev;
}

// IR-LABEL: func %main
// IR: atomicAdd(%{{[^,]+}}, %{{[^,]+}}, {{[^,)]+}})
