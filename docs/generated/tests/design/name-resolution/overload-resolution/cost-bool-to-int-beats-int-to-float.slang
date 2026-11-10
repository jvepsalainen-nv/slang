//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_BoolToInt (120) is cheaper than kConversionCost_IntegerToFloatConversion (400), so a bool argument selects the int overload.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the deliberately-cheap bool-to-int level. A bool argument can reach
// either overload, but the int one accumulates 120 against the float one's
// 400. CHECK asserts the int overload's tag.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int x)   { return 1; }
int pick(float x) { return 2; }

void main()
{
    bool b = true;
    int tag = pick(b);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
