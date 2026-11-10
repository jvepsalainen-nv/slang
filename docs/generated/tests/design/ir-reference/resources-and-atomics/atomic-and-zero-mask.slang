//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<int>::and(0)` (clear-all-bits mask) still lowers to the documented `atomicAnd` opcode shape.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: AND with zero clears every bit; the opcode is
// emitted regardless of the constant's annihilating property.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int prev = abuf[idx].and(0);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicAnd(%{{[^,]+}}, 0 : Int, {{.*}})
