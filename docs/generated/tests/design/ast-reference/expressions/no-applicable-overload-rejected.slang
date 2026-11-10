//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#overloadedexpr-and-overloadedexpr2
//META: purpose=When the call's argument type does not match any candidate parameter type, the InvokeExpr is rejected (the overload set collapse fails to find a match).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a call whose argument matches no candidate is rejected rather
// than silently coerced. The only candidate takes an `int` and the argument is
// a struct; the CHECK pins the type-mismatch error code the checker reports
// when the candidate set collapses to nothing.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S { int v; }

void foo(int a) { }

void notMain()
{
    S s;
    foo(s);
/*CHECK:
        ^ type mismatch in expression
        ^ expected an expression of type 'int', got 'S'
*/
// CHECK: E30019
}
