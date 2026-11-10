//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that `uint8_t(255) + uint8_t(1)` wraps to 0 — narrow unsigned overflow for the uint8 base type.
//META: intent=stress
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// MAX+1 for the narrow uint8 base type. The IntegerLiteralExpr at 255
// constructed via uint8_t(...) holds the unsigned MAX; +1 must wrap
// to 0, matching documented unsigned semantics on the narrow type.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    uint8_t a = uint8_t(255);
    uint8_t b = a + uint8_t(1);
    // CHECK: b=0
    printf("b=%d\n", int(b));
}
