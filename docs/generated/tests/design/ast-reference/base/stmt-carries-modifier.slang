//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#stmt-modifiablesyntaxnode
//META: purpose=A Stmt inherits a modifiers list, which is why an attribute may be written in front of a statement and still leave the statement type-checking and executing.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an attribute written before a statement attaches to
// that statement instead of being rejected. `[unroll]` sits in front
// of a `for`; CHECK asserts the loop still runs and accumulates
// 0+1+2+3, which requires the annotated statement to have checked and
// executed normally.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    [unroll]
    for (int i = 0; i < 4; ++i)
    {
        sum = sum + i;
    }
    //CHECK: sum=6
    printf("sum=%d\n", sum);
}
