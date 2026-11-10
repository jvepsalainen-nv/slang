//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#returnstmt
//META: purpose=The checker matches a ReturnStmt's expression against the enclosing function's declared return type; `return 1;` in a `void` function is rejected because `int` does not implicitly convert to `void`.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the return-type matching runs at the void boundary too:
// only a null expression is admissible for a `void` return, so a
// `return 1;` in a `void` function must fail the checker's match of
// the expression against the declared return type. The CHECK pins
// E30019 on the returned literal; a checker that skipped the match
// for void functions would accept this silently.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void f()
{
    return 1;
/*CHECK:
           ^ type mismatch in expression
           ^ expected an expression of type 'void', got 'int'
           ^ explicit conversion from 'int' to 'void' is possible
*/
// CHECK: E30019
}
