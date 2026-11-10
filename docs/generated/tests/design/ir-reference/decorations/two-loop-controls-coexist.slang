//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#loop-and-branch-hints
//META: purpose=Two for-loops decorated with different loop-control attributes ([unroll] vs [loop]) each get their own loopControl decoration with the matching mode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `loopControl` is attached per loop inst and keeps its own
// mode. Two adjacent loops in one function use opposite attributes and the
// CHECK-DAG lines pin both mode integers (0 and 1), so a lowering that
// attached the first hint to both loops would fail.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int s = 0;
    [unroll]
    for (int i = 0; i < 4; i++) s += int(tid.x) * i;
    [loop]
    for (int j = 0; j < 8; j++) s += int(tid.y) * j;
    buf[0] = s;
}

// CHECK-DAG: [loopControl(0 : Int)]
// CHECK-DAG: [loopControl(1 : Int)]
