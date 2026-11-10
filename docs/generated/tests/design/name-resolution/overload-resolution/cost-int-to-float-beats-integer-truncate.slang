//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_IntegerToFloatConversion (400) is cheaper than kConversionCost_IntegerTruncate (450), so an int argument prefers a float parameter over a narrower integer one.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the near-neighbour pair in the cost table: crossing to float is
// ranked cheaper than narrowing within the integer family. Both overloads are
// viable for an int argument; CHECK asserts the float one fired.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int8_t x) { return 1; }
int pick(float x)  { return 2; }

void main()
{
    int a = 5;
    int tag = pick(a);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
