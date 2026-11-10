//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<T>::add(v)` lowers to `atomicAdd(%ptr, %val, %order)`, the IR encoding of the atomic add primitive.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `Atomic<int>::add(v)` lowers to the documented three-operand
// `atomicAdd(%ptr, %val, %memoryOrder)` shape. The portable surface is
// the `Atomic<T>::add(v)` method on a `RWStructuredBuffer` element; the
// CHECK pins exactly one trailing operand after the value — the
// `IRMemoryOrder` constant (`0 : Int` is relaxed) that the operand
// column now names explicitly.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int prev = abuf[idx].add(idx + 1);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicAdd(%{{[^,]+}}, %{{[^,]+}}, {{[^,)]+}})
