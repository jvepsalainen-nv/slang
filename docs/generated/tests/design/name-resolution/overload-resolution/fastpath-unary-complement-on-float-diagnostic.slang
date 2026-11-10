//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#the-builtin-operator-fast-path
//META: purpose=Unary ~ applied to a builtin floating-point operand is diagnosed by the fast path with bitwise-operator-requires-integer-operands.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the unary arm of the fast path's own diagnosis: `~` on a float
// operand is rejected before candidate collection. CHECK pins the
// bitwise/shift operand diagnostic on the `~` token.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    float f = 1.0f;
    float r = ~f;
//CHECK:      ^ bitwise/shift operator '~' requires integer operands
    printf("%f\n", r);
}
