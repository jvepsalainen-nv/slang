//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A LetDecl is a `let` variable and is immutable; assignment through a let-bound name is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `let` binding is immutable. The test assigns through a
// let-bound local; the CHECK pins the l-value diagnostic (E30011) at the
// name, which is the only user-visible way immutability manifests.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    let x = 1;
    x = 2;
/*CHECK:
      ^ left of '=' is not an l-value
*/
// CHECK: E30011
}
