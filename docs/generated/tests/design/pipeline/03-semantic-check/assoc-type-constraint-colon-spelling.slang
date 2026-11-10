//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=An associated-type constraint written as `associatedtype A : IBar` is recorded as a requirement of the enclosing interface, so generic code can call IBar's methods on the associated type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the first of the three spellings the checker unifies. The generic
// `use` is bounded only by `IHolder`; calling `bar()` on the value of type
// `T.Item` type-checks only if the `: IBar` constraint became a requirement of
// `IHolder` that the conformance witness carries. CHECK asserts the value the
// conformer's `bar()` returns.

//TEST:INTERPRET(filecheck=CHECK):

interface IBar
{
    int bar();
}

interface IHolder
{
    associatedtype Item : IBar;
    Item get();
}

struct Coin : IBar
{
    int bar() { return 3; }
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
    // CHECK: v=3
    printf("v=%d\n", use(p));
}
