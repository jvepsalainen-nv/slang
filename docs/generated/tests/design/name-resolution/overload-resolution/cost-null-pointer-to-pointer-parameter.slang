//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversion-costs
//META: purpose=kConversionCost_NullPtrToPtr (150) makes nullptr reach a Ptr parameter, selecting the pointer overload over an int one.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the nullptr-to-pointer row of the cost table. `nullptr` has its own
// NullPtr type, so only the Ptr candidate survives the type step; CHECK
// asserts the pointer overload's tag.

//TEST:INTERPRET(filecheck=CHECK):

int pick(Ptr<int> p) { return 1; }
int pick(int v)      { return 2; }

void main()
{
    int tag = pick(nullptr);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
