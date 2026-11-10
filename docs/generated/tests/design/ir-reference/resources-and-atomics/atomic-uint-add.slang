//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<uint>::add(v)` lowers to `atomicAdd` exactly as for `int`, with the value typed as `UInt` in the operand position.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The atomic family is documented in terms of a pointer operand;
// the element type is whatever the `Atomic<T>` is parameterized on.
// Exercise the `uint` element type to confirm the opcode is the
// same name, with the value carrying `UInt` typing. The CHECK pins a
// single trailing memory-order operand per the documented
// `ptr, val, memoryOrder` shape.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<uint>> abuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint idx = tid.x;
    uint prev = abuf[idx].add(1u);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicAdd(%{{[^,]+}}, 1 : UInt, {{[^,)]+}})
