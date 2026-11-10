//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A PrefixExpr `--x` is the prefix decrement operator; its value is the post-decrement value of the operand.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Prefix-form `--x` reduces x by 1 and yields the new value. After
// `int v = --i;` we expect both v and i to be one less than the
// original value of i.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int i = 10;
    int v = --i;
    // CHECK: v=9
    printf("v=%d\n", v);
    // CHECK: i=9
    printf("i=%d\n", i);
}
