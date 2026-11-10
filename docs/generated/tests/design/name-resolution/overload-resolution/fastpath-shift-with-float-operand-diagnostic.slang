//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#the-builtin-operator-fast-path
//META: purpose=A shift operator with a builtin floating-point operand is diagnosed by the fast path itself with bitwise-operator-requires-integer-operands rather than falling through to a no-overload message.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the fast path diagnoses a float shift operand directly instead
// of handing the expression to overload resolution. CHECK pins the
// bitwise/shift operand diagnostic on the `<<` token; a fall-through would
// instead report "no overload for 'operator<<'".

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    float f = 1.0f;
    int amount = 2;
    int r = f << amount;
//CHECK:      ^^ bitwise/shift operator '<<' requires integer operands
    printf("%d\n", r);
}
