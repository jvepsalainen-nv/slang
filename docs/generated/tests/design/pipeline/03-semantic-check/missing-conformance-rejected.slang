//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=A struct declared as conforming to an interface but missing a required member is rejected with E38100 naming the missing member.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that conformance verification is not satisfied by a merely-declared
// inheritance clause. `S` names `IFoo` as a base but provides `g` instead of
// the required `f`, so no witness can be found or synthesized. CHECK pins
// E38100 and the note pointing at the requirement's declaration.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IFoo
{
    int f();
}

struct S : IFoo
{
    int g() { return 1; }
}
//CHECK: E38100
//CHECK: see declaration of 'f'

void main()
{
}
