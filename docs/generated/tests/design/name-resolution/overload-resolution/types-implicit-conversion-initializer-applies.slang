//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=canCoerce accepts a single user-declared implicit-conversion initializer, so an A argument reaches a B parameter and the candidate becomes applicable.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positive half of the type step's coercion check for a
// user-declared conversion, and gives the nested-conversion negative test its
// baseline: one hop through B's __implicit_conversion initializer is allowed.
// CHECK asserts the value the initializer computed.

//TEST:INTERPRET(filecheck=CHECK):

struct A { int v; }
struct B { int v; __implicit_conversion(0) __init(A a) { v = a.v + 1; } }

int take(B b) { return b.v; }

void main()
{
    A a;
    a.v = 1;
    int r = take(a);
    // CHECK: r=2
    printf("r=%d\n", r);
}
