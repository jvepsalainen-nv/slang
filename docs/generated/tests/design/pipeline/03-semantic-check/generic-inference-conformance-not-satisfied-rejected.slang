//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=An inferred type argument that does not conform to a required interface is reported as an unsatisfied conformance (E38029) naming both types.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the InterfaceConformanceNotSatisfied arm. `T` is inferred as `S`
// from the argument, and only then does the `: IFoo` constraint fail; the arm
// stores the substituted sub- and super-types so the message can name both.
// CHECK pins E38029 and the declaration note.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IFoo
{
    int get();
}

struct S
{
    int x;
}

T pick<T : IFoo>(T a)
{
    return a;
}

void main()
{
    S s;
    pick(s);
//CHECK: E38029
//CHECK: see declaration of
}
