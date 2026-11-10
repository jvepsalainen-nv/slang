//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#varexpr-and-declrefexpr
//META: purpose=A VarExpr whose name lookup finds nothing is rejected with an "undefined identifier" diagnostic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// VarExpr starts life carrying only `name` and `scope`; the checker
// fills in `declRef` by lookup. When lookup finds no decl, the
// checker emits an "undefined identifier" diagnostic at the use
// site.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = undeclaredName;
//CHECK:    ^^^^^^^^^^^^^^ undefined identifier
//CHECK:    ^^^^^^^^^^^^^^ undefined identifier 'undeclaredName'.
// CHECK: E30015
}
