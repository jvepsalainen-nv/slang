//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=disallowNestedConversions stops one user-defined conversion from being stacked on top of another, so an A argument does not reach a C parameter through B.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the checker refuses to chain two user-declared implicit
// conversions. Each single hop is legal on its own (see
// types-implicit-conversion-initializer-applies.slang), but the call asks for
// A -> B -> C in one step; CHECK pins the type-mismatch error the caller sees
// once the nested conversion is disallowed.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct A { int v; }
struct B { int v; __implicit_conversion(0) __init(A a) { v = a.v + 1; } }
struct C { int v; __implicit_conversion(0) __init(B b) { v = b.v + 1; } }

int take(C c) { return c.v; }

void main()
{
    A a;
    a.v = 1;
    int r = take(a);
//CHECK:         ^ expected an expression of type 'C', got 'A'
    printf("%d\n", r);
}
