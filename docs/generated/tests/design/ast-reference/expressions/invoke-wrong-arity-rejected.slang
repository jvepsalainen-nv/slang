//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#invokeexpr-and-the-call--operator--cast-unification
//META: purpose=An InvokeExpr whose argument-list length does not match any candidate is rejected with a "not enough arguments to call" diagnostic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative shape for the InvokeExpr / overload-resolution contract:
// the only candidate takes two parameters; passing one must be
// diagnosed.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void foo(int a, int b) { }
/*CHECK:
     ^^^ candidate: func foo(int, int) -> void
*/

void main()
{
    foo(1);
/*CHECK:
       ^ not enough arguments to call
       ^ not enough arguments to call (got 1, expected 2)
*/
}
