//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#lambdaexpr-and-lambdadecl
//META: purpose=Verifies that a LambdaExpr with zero parameters — `() => 42` — forms a callable that returns the body's constant.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary on LambdaExpr parameter count. The lambda has
// no parameters; invocation must still return the body's value.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    var get42 = () => 42;
    // CHECK: r=42
    printf("r=%d\n", get42());
}
