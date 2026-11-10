//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#member-lookup
//META: purpose=The facet walk reaches an interface facet of a conforming struct, and the struct's own implementation is what a direct receiver call resolves to.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the interface-facet arm of the walk with a concrete
// receiver (no generic indirection). `a.marker()` sees both the
// interface requirement facet and the struct's own member; the call
// must land on the struct's implementation. CHECK asserts 42, the
// value only the struct's body produces.

//TEST:INTERPRET(filecheck=CHECK):

interface IFlag { int marker(); }

struct A : IFlag
{
    int marker() { return 42; }
}

void main()
{
    A a;
    // CHECK: r=42
    printf("r=%d\n", a.marker());
}
