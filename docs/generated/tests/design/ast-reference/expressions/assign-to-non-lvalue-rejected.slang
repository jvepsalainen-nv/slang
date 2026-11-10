//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An AssignExpr whose left side is not an l-value is rejected with a diagnostic about "left of '=' is not an l-value".
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// AssignExpr requires its left to be an l-value. The expression
// `1 + 2` is a temporary, not an l-value; assignment to it must be
// diagnosed.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    1 + 2 = 7;
//CHECK:  ^ left of '=' is not an l-value
//CHECK:  ^ left of '=' is not an l-value.
// CHECK: E30011
}
