//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#loop-and-branch-hints
//META: purpose=A [flatten] attribute on a conditional lowers to a flatten decoration with no operands attached to the conditional inst.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `flatten` row's operand shape: the decoration is nullary, so
// the dump prints a bare `[flatten]`. As in the `branch` sibling the
// condition is thread-id dependent and the result escapes through a buffer
// write, so the conditional is still present when the dump is taken.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = 0;
    [flatten]
    if (tid.x == 0u) v = 10;
    else v = 20;
    buf[0] = v;
}

// CHECK: [flatten]
