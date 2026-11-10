//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<int>::min(INT_MIN)` (degenerate — argument is the absolute minimum) still lowers to the documented `atomicMin` opcode shape.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: smallest possible argument to a min RMW. The
// opcode is emitted regardless of whether the comparison can change
// the stored value.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int prev = abuf[idx].min(-2147483648);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicMin(%{{[^,]+}}, {{.*}}-2147483648{{.*}})
