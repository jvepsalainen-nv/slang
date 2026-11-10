//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=An associated-type constraint written as `associatedtype A where A : IBar` is recorded identically to the inheritance-clause spelling.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `where`-clause spelling reaches the same interface-level
// requirement. The program is the shape of the colon-spelling test with only
// the constraint syntax changed, so a difference in recorded representation
// would show up as a failure to type-check `bar()` in the generic body.
// CHECK asserts the conformer's value came back.

//TEST:INTERPRET(filecheck=CHECK):

interface IBar
{
    int bar();
}

interface IHolder
{
    associatedtype Item where Item : IBar;
    Item get();
}

struct Coin : IBar
{
    int bar() { return 4; }
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
    // CHECK: v=4
    printf("v=%d\n", use(p));
}
