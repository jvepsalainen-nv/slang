//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<T>::increment()` and `::decrement()` lower to the nullary-value opcodes `atomicInc(%ptr, %order)` and `atomicDec(%ptr, %order)`, which carry no value operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two atomics whose only operands are the destination
// pointer and the memory order. Both methods are called on the same
// buffer element and their results are summed into an output buffer so
// nothing is dead; the CHECKs assert exactly two operands per opcode,
// which is what distinguishes `atomicInc`/`atomicDec` from the
// read-modify-write atomics that take a value.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int a = abuf[idx].increment();
    int b = abuf[idx].decrement();
    rwbuf[idx] = a + b;
}

// IR-LABEL: func %main
// IR: atomicInc(%{{[^,]+}}, {{[^,)]+}})
// IR: atomicDec(%{{[^,]+}}, {{[^,)]+}})
