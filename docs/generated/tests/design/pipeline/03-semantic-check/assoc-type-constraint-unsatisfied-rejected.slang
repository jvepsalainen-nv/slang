//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=A conformer whose associated type does not satisfy the interface-level constraint is rejected, because the constraint requirement is re-checked as a subtype relation after `This` is replaced by the conforming type.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the negative half of the interface-level-constraint claim. `Plain`
// does not implement `IBar`, so binding it to `Item` leaves the hoisted
// constraint requirement unsatisfiable; the checker reports it against the
// conformance rather than against the member. CHECK pins E38029 naming the
// conforming type and the interface.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IBar
{
    int bar();
}

interface IHolder
{
    associatedtype Item : IBar;
    Item get();
}

struct Plain
{
    int x;
}

struct Purse : IHolder
{
    typealias Item = Plain;
    Plain get() { Plain p; return p; }
}
//CHECK: E38029

void main()
{
}
