//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#stmt-modifiablesyntaxnode
//META: purpose=The modifiers list a Stmt inherits is a list, so several attributes may be stacked in front of one statement and all of them attach.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a statement's modifier storage holds more than one
// entry. Two attributes are stacked on a single `for`; if only one
// slot existed the second would be dropped or diagnosed. CHECK asserts
// the loop still runs to completion with both attached, and the
// `[MaxIters(8)]` bound is satisfied by the five iterations performed.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    [loop]
    [MaxIters(8)]
    for (int i = 0; i < 5; ++i)
    {
        sum = sum + i;
    }
    //CHECK: sum=10
    printf("sum=%d\n", sum);
}
