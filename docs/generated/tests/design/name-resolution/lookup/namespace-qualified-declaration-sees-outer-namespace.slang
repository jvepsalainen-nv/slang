//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#module-and-namespace
//META: purpose=A namespace declared with a qualified name such as A::B resolves unqualified names against the enclosing namespace A, because each lexical scope of a namespace is wired to the same-named namespaces visible from its parent chain.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies scope wiring for `namespace A::B`. The body of `f` names
// `x()` without qualification; `x` lives in a separate `namespace A`
// block, so the reference resolves only if the lexical scope created
// for the qualified declaration reaches the merged `A`. CHECK asserts
// the value 5 flows through.

//TEST:INTERPRET(filecheck=CHECK):

namespace A { int x() { return 5; } }

namespace A::B
{
    int f() { return x(); }
}

void main()
{
    // CHECK: r=5
    printf("r=%d\n", A::B::f());
}
