//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_ScalarToVector is additive on top of the element conversion, so an exact scalar match beats promoting the same argument to a vector.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the scalar-to-vector promotion is a real (nonzero) cost rather
// than a free reshape: with an int argument the int3 overload is viable but
// strictly more expensive than the int one. CHECK asserts the scalar overload
// fired.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int x)  { return 1; }
int pick(int3 v) { return 3; }

void main()
{
    int a = 7;
    int tag = pick(a);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
