//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#nodes
//META: purpose=A ModifiedType applies a modifier to a base type; a `const`-modified local is not an l-value, so assigning to it is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the modifier really participates in the type rather
// than being dropped after parsing: a `const int` local still accepts
// its initialiser but refuses a later assignment. CHECK pins the
// not-an-l-value diagnostic, which a plain `int` would not produce.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    const int x = 42;
    x = 1;
/*CHECK:
      ^ left of '=' is not an l-value.
*/
}
