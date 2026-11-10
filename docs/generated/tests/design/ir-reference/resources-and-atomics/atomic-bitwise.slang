//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<T>::and(v)` / `or(v)` / `xor(v)` lower to `atomicAnd` / `atomicOr` / `atomicXor` with the standard `(ptr, val, order)` operand shape.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the three bitwise read-modify-write atomics each get
// their own opcode. They share one file because they share one operand
// shape; each call uses a distinct mask literal so the CHECKs cannot
// match each other's line, and each allows exactly one trailing operand
// — the memory order.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int pa = abuf[idx].and(0xff);
    int po = abuf[idx].or(0xf0);
    int px = abuf[idx].xor(0x0f);
    rwbuf[idx] = pa + po + px;
}

// IR-LABEL: func %main
// IR: atomicAnd(%{{[^,]+}}, 255 : Int, {{[^,)]+}})
// IR: atomicOr(%{{[^,]+}}, 240 : Int, {{[^,)]+}})
// IR: atomicXor(%{{[^,]+}}, 15 : Int, {{[^,)]+}})
