//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#ifelse
//META: purpose=With -minimum-slang-optimization the mandatory simplifyCFG is skipped, so an if with an empty then-arm keeps its own then block: trueBlock and afterBlock stay distinct in the first dump.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Companion to ifelse-empty-then-arm.slang. The doc says the fold of an
// empty arm onto the merge block happens only when minimum optimizations are
// off. With -minimum-slang-optimization the empty then-arm survives as its own
// block (which just branches to the merge block), so the ifElse operands are
// four distinct blocks and the then block contains only the branch.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -minimum-slang-optimization

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    if (a > 0)
    {
        // empty then-arm
    }
    else
    {
        buf[1] = a;
    }
    buf[0] = a;
}

// CHECK-LABEL: func %main
// CHECK: ifElse(%{{[0-9]+}}, %[[THEN:[0-9]+]], %[[ELSE:[0-9]+]], %[[AFTER:[0-9]+]])
// CHECK: block %[[THEN]]:
// CHECK-NEXT: unconditionalBranch(%[[AFTER]])
// CHECK: block %[[ELSE]]:
