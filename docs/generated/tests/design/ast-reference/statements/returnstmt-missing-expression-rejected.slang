//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#returnstmt
//META: purpose=A ReturnStmt in a non-void function is required to carry an expression; `return;` is rejected with `'return' should have an expression`.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the returned expression is matched against the enclosing
// function's declared return type, so a non-void function cannot use a
// bare `return;`. The CHECK pins the E30006 diagnostic on the `return`
// token.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int f()
{
    return;
/*CHECK:
    ^^^^^^ 'return' should have an expression
    ^^^^^^ 'return' should have an expression.
*/
// CHECK: E30006
}
