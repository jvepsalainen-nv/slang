//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that an arithmetic underflow to -inf compares less than the smallest finite (negated MAX) float literal.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// -inf boundary. Multiplying the negated largest finite by 10 yields
// -inf; the result must order strictly below the most negative finite.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float big = 3.4e38f;
    float ninfv = -big * 10.0f;
    // CHECK: lt-min=1
    printf("lt-min=%d\n", int(ninfv < -big));
}
