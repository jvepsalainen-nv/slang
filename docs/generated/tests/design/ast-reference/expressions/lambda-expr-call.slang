//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#lambdaexpr-and-lambdadecl
//META: purpose=A LambdaExpr `(params) => { body }` forms a callable that returns the body's value when invoked.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `(params) => body` forms a callable value that returns the
// body's result when invoked. The lambda is bound to a local and then called
// with a concrete argument; the CHECK asserts the body's arithmetic ran.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    var add = (int x, int y) => x + y;
    // CHECK: r=12
    printf("r=%d\n", add(5, 7));
}
