//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_InRangeIntLitSignedToUnsignedConversion (32) is cheaper than kConversionCost_IntegerToFloatConversion (400), so an in-range integer literal selects the uint overload.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the in-range-literal cost level, which only applies to a literal (a
// non-literal int would instead pay the 250-level signed-to-unsigned cost).
// Both overloads are viable for the literal 3; CHECK asserts the uint one won.

//TEST:INTERPRET(filecheck=CHECK):

int pick(uint x)  { return 2; }
int pick(float x) { return 3; }

void main()
{
    int tag = pick(3);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
