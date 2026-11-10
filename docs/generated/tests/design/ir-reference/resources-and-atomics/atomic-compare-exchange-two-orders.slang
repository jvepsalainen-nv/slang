//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomiccompareexchange
//META: purpose=`atomicCompareExchange` is the only atomic with two memory orders: `ptr, expected, desired` are followed by a success order at operand 3 and a failure order at operand 4.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the five-operand CAS shape. `expected` and `desired` are both
// derived from `SV_DispatchThreadID` so neither collapses to a literal,
// which leaves the two trailing operands as the only constants on the
// line; the CHECK pins them as `0 : Int, 0 : Int`, showing that both the
// success and the failure order are materialized separately rather than
// shared.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int prev = abuf[idx].compareExchange(idx, idx + 1);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicCompareExchange(%{{[^,]+}}, %{{[^,]+}}, %{{[^,]+}}, 0 : Int, 0 : Int)
