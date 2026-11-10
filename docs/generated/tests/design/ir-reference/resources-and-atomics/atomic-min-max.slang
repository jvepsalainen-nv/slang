//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<T>::min(v)` and `::max(v)` lower to `atomicMin(%ptr, %val, %order)` and `atomicMax(%ptr, %val, %order)` respectively.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `min` and `max` are separate read-modify-write opcodes
// rather than a compare-and-store sequence. Both methods are called on
// the same buffer element and each CHECK allows exactly one operand
// after the value, which pins the `(ptr, val, order)` shape shared by
// the whole read-modify-write family.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int pmin = abuf[idx].min(10);
    int pmax = abuf[idx].max(100);
    rwbuf[idx] = pmin + pmax;
}

// IR-LABEL: func %main
// IR: atomicMin(%{{[^,]+}}, 10 : Int, {{[^,)]+}})
// IR: atomicMax(%{{[^,]+}}, 100 : Int, {{[^,)]+}})
