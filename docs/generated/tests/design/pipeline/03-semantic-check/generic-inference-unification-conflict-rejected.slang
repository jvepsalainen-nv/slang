//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=Two arguments that force one generic parameter to two different types are reported as a unification conflict (E30442) naming both candidates.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the GenericParamUnificationConflict arm. `T` is constrained by both
// parameters, and the two struct arguments are unrelated so neither converts
// to the other; the arm records both candidate types for the message. CHECK
// pins E30442 and the declaration note.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct A
{
    int a;
}

struct B
{
    int b;
}

void two<T>(T a, T b)
{
}

void main()
{
    A x;
    B y;
    two(x, y);
//CHECK: E30442
//CHECK: see declaration of
}
