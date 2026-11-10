//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#loop-and-branch-hints
//META: purpose=A [branch] attribute on a conditional lowers to a branch decoration with no operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `branch` row's operand shape: the decoration is nullary, so
// the dump prints a bare `[branch]` line on the conditional it annotates.
// The condition reads the dispatch thread id and the selected value escapes
// through a buffer write, so neither folding nor DCE can remove the
// conditional before the CHECK sees its decoration.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = 0;
    [branch]
    if (tid.x == 0u) v = 10;
    else v = 20;
    buf[0] = v;
}

// CHECK: [branch]
