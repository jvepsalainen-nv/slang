//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=An associated-type constraint written as a standalone `__constraint A : IBar` inside the interface is recorded identically to the other two spellings.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the third spelling: the constraint is written as a sibling of the
// associated type rather than attached to it, which is exactly the uniform
// representation the checker builds for all three. If this spelling were
// nested under `Item` instead, the generic body could not reach `bar()`.
// CHECK asserts the conformer's value came back.

//TEST:INTERPRET(filecheck=CHECK):

interface IBar
{
    int bar();
}

interface IHolder
{
    associatedtype Item;
    __constraint Item : IBar;
    Item get();
}

struct Coin : IBar
{
    int bar() { return 5; }
}

struct Purse : IHolder
{
    typealias Item = Coin;
    Coin get() { Coin c; return c; }
}

int use<T : IHolder>(T holder)
{
    return holder.get().bar();
}

void main()
{
    Purse p;
    // CHECK: v=5
    printf("v=%d\n", use(p));
}
