//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_InRangeIntLitConversion (23) is cheaper than kConversionCost_IntegerToFloatConversion (400), so an in-range integer literal selects the int16_t overload.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the in-range-integer-literal row of the cost table. The literal 5
// fits in int16_t, so that candidate accumulates 23 while the float candidate
// accumulates 400; CHECK asserts the int16_t overload's tag.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int16_t x) { return 1; }
int pick(float x)   { return 2; }

void main()
{
    int tag = pick(5);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
