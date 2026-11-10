//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#invokeexpr-and-the-call--operator--cast-unification
//META: purpose=Verifies an InvokeExpr with zero arguments — `f()` — calls the function and returns its result.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary for InvokeExpr.arguments: the empty list.
// `f()` must construct an InvokeExpr with no args and dispatch
// correctly to the zero-arg overload.

//TEST:INTERPRET(filecheck=CHECK):

int five() { return 5; }

void main()
{
    // CHECK: r=5
    printf("r=%d\n", five());
}
