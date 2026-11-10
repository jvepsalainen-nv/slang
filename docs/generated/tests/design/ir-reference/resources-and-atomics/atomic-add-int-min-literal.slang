//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#atomic-operations
//META: purpose=`Atomic<int>::add(INT_MIN)` (smallest signed value, `-2147483648`) still lowers to the documented `atomicAdd` opcode; the negative literal is carried unchanged.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe at the smallest representable 32-bit signed value.
// The claim under test is only about opcode shape — nothing commits to
// runtime wrap-around — so the CHECK asserts that `-2147483648` reaches
// `atomicAdd` as an ordinary value operand and is neither rejected nor
// rewritten on the way down.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<Atomic<int>> abuf;
uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int prev = abuf[idx].add(-2147483648);
    rwbuf[idx] = prev;
}

// IR-LABEL: func %main
// IR: atomicAdd(%{{[^,]+}}, {{.*}}-2147483648{{.*}})
