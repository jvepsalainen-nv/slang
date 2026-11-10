//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<T>::load()` and `::store(v)` lower to the dedicated `atomicLoad(%ptr, %order)` and `atomicStore(%ptr, %val, %order)` opcodes (separate from the RMW ops).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the two non-read-modify-write atomics have their own
// opcodes with their own operand counts. The CHECKs allow one operand
// after the pointer for the load and one after the value for the store,
// which is how the memory-order operand's position differs between
// them.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int v = abuf[idx].load();
    abuf[idx].store(42);
    rwbuf[idx] = v;
}

// IR-LABEL: func %main
// IR: atomicLoad(%{{[^,]+}}, {{[^,)]+}})
// IR: atomicStore(%{{[^,]+}}, 42 : Int, {{[^,)]+}})
