//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_IntegerToFloatConversion (400) is cheaper than kConversionCost_IntegerToHalfConversion (500), so an int variable prefers the float overload over the half one.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the cost table separates int-to-float from int-to-half. Both
// overloads accept an int argument, but half costs 500 against float's 400, so
// the float candidate wins; CHECK asserts its tag.

//TEST:INTERPRET(filecheck=CHECK):

int pick(half x)  { return 1; }
int pick(float x) { return 2; }

void main()
{
    int v = 5;
    int tag = pick(v);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
