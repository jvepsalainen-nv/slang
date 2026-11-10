//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#basicexpressiontype-vectorexpressiontype-matrixexpressiontype
//META: purpose=An integer literal too large to be represented in any integer BasicExpressionType is diagnosed rather than silently truncated.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative boundary probe past the top of every integer arithmetic
// leaf: no scalar built-in can hold the literal, so the checker must
// reject it instead of wrapping. CHECK pins the too-large-literal
// diagnostic and the conversion-overflow companion on the same span.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    uint x = 99999999999999999999;
//CHECK:     ^^^^^^^^^^^^^^^^^^^^ integer literal is too large to be represented in any integer type
//CHECK:     ^^^^^^^^^^^^^^^^^^^^ integer constant overflow in conversion
}
