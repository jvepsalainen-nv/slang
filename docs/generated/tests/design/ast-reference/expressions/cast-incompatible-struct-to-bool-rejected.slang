//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An ExplicitCastExpr from a struct to bool is rejected because no conversion exists — a distinct destination type from the existing struct-to-int negative case.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Different destination type than the sibling cast-incompatible-rejected
// negative test. The TypeCastExpr family must reject struct->bool too.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S { int a; }

void main()
{
    S s;
    bool x = (bool) s;
//CHECK:            ^ type mismatch in expression
//CHECK:            ^ expected an expression of type 'bool', got 'S'
// CHECK: E30019
}
