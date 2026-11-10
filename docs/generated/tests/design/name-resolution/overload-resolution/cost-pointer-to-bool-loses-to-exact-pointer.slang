//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_PtrToBool (400) makes a pointer argument lose to an exact Ptr parameter while still being convertible to bool.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the pointer-to-bool row of the cost table. Taking the address of a
// local produces a Ptr<int> that both overloads accept, but the bool candidate
// pays 400 against the exact match's 0; CHECK asserts the pointer tag.

//TEST:INTERPRET(filecheck=CHECK):

int pick(Ptr<int> p) { return 1; }
int pick(bool b)     { return 2; }

void main()
{
    int x = 5;
    int tag = pick(&x);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
