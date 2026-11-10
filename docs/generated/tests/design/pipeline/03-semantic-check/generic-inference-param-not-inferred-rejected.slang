//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=A generic type parameter that appears nowhere in the value parameter list is reported as un-inferable (E30439) naming that parameter.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the OrdinaryGenericParamNotInferred arm. `T` is mentioned only in
// the generic parameter list, so no argument can ever determine it and the
// solver's constraint for it stays unsatisfied; the stored parameter decl is
// what lets the message name `T`. CHECK pins E30439 and the declaration note.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void f<T>(int a)
{
}

void main()
{
    f(1);
//CHECK: E30439
//CHECK: see declaration of
}
