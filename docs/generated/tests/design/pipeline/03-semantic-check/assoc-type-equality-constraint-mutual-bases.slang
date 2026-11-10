//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=An `__constraint A == B` equality makes `T.A` and `T.B` mutual bases, so an interface method reachable through one associated type is also reachable through the other.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the benevolent-cycle behaviour of an equality constraint. Only
// `Item` carries the `: IBar` bound; `Alt` carries none. Calling `bar()` on a
// value of type `T.Alt` therefore succeeds only if the equality constraint
// added `T.Item` (and with it `IBar`) as a base of `T.Alt` while the
// inheritance walk tolerated the resulting cycle. CHECK asserts the value.

//TEST:INTERPRET(filecheck=CHECK):

interface IBar
{
    int bar();
}

interface IPair
{
    associatedtype Item : IBar;
    associatedtype Alt;
    __constraint Item == Alt;
    Alt getAlt();
}

struct Coin : IBar
{
    int bar() { return 9; }
}

struct P : IPair
{
    typealias Item = Coin;
    typealias Alt = Coin;
    Coin getAlt() { Coin c; return c; }
}

int use<T : IPair>(T p)
{
    return p.getAlt().bar();
}

void main()
{
    P p;
    // CHECK: v=9
    printf("v=%d\n", use(p));
}
