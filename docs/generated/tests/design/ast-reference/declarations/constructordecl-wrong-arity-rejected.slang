//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A ConstructorDecl's parameter list is part of the type's API; calling the constructor with the wrong arity is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that constructor calls go through ordinary overload resolution
// against the declared `__init` signature. A two-argument call is made against
// a one-parameter constructor; the CHECK pins the resolution failure, showing
// the constructor is not a catch-all initializer.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct Wrap
{
    int v;
    __init(int x) { v = x; }
}

void main()
{
    Wrap w = Wrap(1, 2);
//CHECK: error
//CHECK: E39999
}
