//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#type-val
//META: purpose=A type expression must resolve to a type value before a declaration can use it, so an unresolvable spelling in a parameter's type slot is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the negative side of the type-as-value claim: the name in a
// parameter's type position resolves to nothing, so no type value can
// be built for the parameter and the declaration is rejected. CHECK
// pins E30015 with the caret under the type spelling itself.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void f(NotARealTypeName x) {}
/*CHECK:
       ^^^^^^^^^^^^^^^^ undefined identifier
       ^^^^^^^^^^^^^^^^ undefined identifier 'NotARealTypeName'.
*/
// CHECK: E30015

void main() {}
