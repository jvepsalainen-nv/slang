//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#lambdaexpr-and-lambdadecl
//META: purpose=Verifies that a LambdaExpr capturing a single enclosing local variable reads its value through the synthesized LambdaDecl environment struct.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a lambda body can read an enclosing local, i.e. that the
// capture is carried into the closure. The captured local is set before the
// lambda is formed and the lambda is invoked afterwards; the CHECK asserts the
// captured value reached the body.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int delta = 10;
    var addDelta = (int x) => x + delta;
    // CHECK: r=17
    printf("r=%d\n", addDelta(7));
}
