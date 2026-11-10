//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#loop-and-branch-hints
//META: purpose=An [unroll] attribute on a for-loop emits a loopControl decoration on the loop with mode operand 0.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `loopControl` row on the unroll side: the attribute becomes
// a decoration on the loop inst whose single constant operand records the
// mode. The CHECK pins the literal 0, which is the value the dump prints
// for `[unroll]` and which the `[loop]` sibling test distinguishes from 1.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int s = 0;
    [unroll]
    for (int i = 0; i < 4; i++) s += int(tid.x) * i;
    buf[0] = s;
}

// CHECK: [loopControl(0 : Int)]
