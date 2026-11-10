//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_RankPromotion (150) is cheaper than kConversionCost_IntegerToFloatConversion (400), so widening int to int64_t beats converting it to float.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the ordering of two same-kind-vs-different-kind conversions: a
// lossless widening within the integer family is ranked far below crossing into
// the floating-point family. CHECK asserts the int64_t overload fired.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int64_t x) { return 1; }
int pick(float x)   { return 2; }

void main()
{
    int a = 5;
    int tag = pick(a);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
