//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#block-local-shadowing
//META: purpose=The hidden-until-declared rule applies only to local variables, so a struct declared later in the same block is still found by an earlier reference.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the local-variable qualifier on the block-local hiding
// rule. A struct declared inside a function body is not a local
// variable, so the filter does not suppress it and the earlier
// declaration of `Later l` resolves. CHECK asserts the field written
// through that variable reads back as 3, which requires the type to
// have resolved before its textual declaration.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    Later l;
    l.v = 3;

    struct Later { int v; }

    // CHECK: r=3
    printf("r=%d\n", l.v);
}
