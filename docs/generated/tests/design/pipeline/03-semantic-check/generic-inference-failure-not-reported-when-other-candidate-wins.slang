//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=A generic candidate whose specialization failed produces no diagnostic when overload resolution selects a different candidate, because the failure is only formatted for the selected one.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "captured eagerly, reported lazily" half of the claim. The
// generic `pick<T : IFoo>` cannot be specialized for `S`, but a non-generic
// `pick(S)` overload is applicable and wins. If the recorded failure were
// reported at capture time the program would not compile at all; CHECK
// asserts the non-generic overload ran and the program produced a value.

//TEST:INTERPRET(filecheck=CHECK):

interface IFoo
{
    int get();
}

struct S
{
    int x;
}

int pick<T : IFoo>(T a)
{
    return a.get();
}

int pick(S a)
{
    return 8;
}

void main()
{
    S s;
    // CHECK: v=8
    printf("v=%d\n", pick(s));
}
