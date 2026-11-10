//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that the TypeCastExpr `uint(-1)` wraps to 0xFFFFFFFF — the documented two's-complement reinterpretation across the sign boundary.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Sign-boundary cast: a signed -1 becomes the unsigned MAX. The
// TypeCastExpr must preserve the bit pattern across the conversion.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int neg = -1;
    uint u = uint(neg);
    // CHECK: u=4294967295
    printf("u=%u\n", u);
}
