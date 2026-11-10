//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<int>::max(INT_MAX)` (degenerate — argument is the absolute maximum) still lowers to the documented `atomicMax` opcode shape.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: largest possible argument to a max RMW.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int prev = abuf[idx].max(2147483647);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicMax(%{{[^,]+}}, 2147483647 : Int, {{.*}})
