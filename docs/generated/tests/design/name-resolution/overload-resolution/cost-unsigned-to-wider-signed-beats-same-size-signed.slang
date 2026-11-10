//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_UnsignedToSignedPromotion (200) is cheaper than kConversionCost_SameSizeUnsignedToSignedConversion (300), so a uint argument prefers int64_t over int.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two unsigned-to-signed levels against each other. A uint
// argument can widen losslessly into int64_t (200) or reinterpret into the
// same-size int (300); CHECK asserts the int64_t overload fired.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int x)     { return 1; }
int pick(int64_t x) { return 2; }

void main()
{
    uint a = 3;
    int tag = pick(a);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
