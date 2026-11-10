//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#invokeexpr-and-the-call--operator--cast-unification
//META: purpose=Stresses InvokeExpr.arguments with eight positional arguments — the call must dispatch and the eight values must arrive in order.
//META: intent=stress
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress for InvokeExpr argument-list length. Eight ints arrive
// positionally; their sum is 36 (1+...+8). Ordering matters: the
// argument-position bookkeeping must survive into the call.

//TEST:INTERPRET(filecheck=CHECK):

int sum8(int a, int b, int c, int d, int e, int f, int g, int h)
{
    return a + b + c + d + e + f + g + h;
}

void main()
{
    // CHECK: s=36
    printf("s=%d\n", sum8(1, 2, 3, 4, 5, 6, 7, 8));
}
