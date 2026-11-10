//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that PrefixExpr `--x` at the lower-edge value 0 produces -1 on a signed type.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary for prefix decrement: stepping below zero
// must cross the sign boundary on the signed int type.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 0;
    --x;
    // CHECK: x=-1
    printf("x=%d\n", x);
}
