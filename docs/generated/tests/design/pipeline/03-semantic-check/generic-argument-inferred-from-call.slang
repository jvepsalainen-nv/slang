//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=The constraint solver infers a generic function's type argument from the actual argument at the call site.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the basic inference path the solver's fixpoint provides. No
// explicit generic argument is written, so `T` can only come from unifying the
// parameter type with the argument type at each call. Two different argument
// types go through the same declaration; CHECK asserts each returned its own
// value, which requires two distinct successful inferences.

//TEST:INTERPRET(filecheck=CHECK):

T identity<T>(T v)
{
    return v;
}

void main()
{
    // CHECK: i=6 f=1.5
    printf("i=%d f=%.1f\n", identity(6), identity(1.5f));
}
