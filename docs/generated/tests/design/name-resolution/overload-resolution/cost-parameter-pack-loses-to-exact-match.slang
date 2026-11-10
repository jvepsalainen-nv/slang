//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_ParameterPack (500) makes binding to a variadic pack lose to an exact non-pack match of cost 0.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the parameter-pack row of the cost table. Both the plain int
// overload and the variadic pack overload accept a single int argument, but
// the pack binding costs 500 against the exact match's 0; CHECK asserts the
// non-pack tag.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int x) { return 1; }
int pick<each T>(expand each T args) { return 2; }

void main()
{
    int v = 3;
    int tag = pick(v);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
