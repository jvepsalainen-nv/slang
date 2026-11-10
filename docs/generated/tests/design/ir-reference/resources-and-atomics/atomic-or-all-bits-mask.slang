//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<uint>::or(UINT_MAX)` (set-all-bits mask) still lowers to the documented `atomicOr` opcode shape.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: OR with all-bits-set is the saturating constant
// for OR; opcode is emitted nonetheless.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<uint>> abuf;
uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint idx = tid.x;
    uint prev = abuf[idx].or(0xFFFFFFFFu);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicOr(%{{[^,]+}}, 4294967295 : UInt, {{.*}})
