//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that `__floatAsInt(e)` reinterprets a float's bit pattern as an integer at compile time.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The float-bits reinterpretation is a distinct expression form rather than a
// numeric conversion. `1.0f` has the IEEE-754 binary32 encoding 0x3F800000,
// so the CHECK asserting 1065353216 fails if the expression converted the
// value numerically (which would yield 1) instead of reinterpreting its bits.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: one=1065353216
    printf("one=%d\n", __floatAsInt(1.0f));
    // CHECK: zero=0
    printf("zero=%d\n", __floatAsInt(0.0f));
}
