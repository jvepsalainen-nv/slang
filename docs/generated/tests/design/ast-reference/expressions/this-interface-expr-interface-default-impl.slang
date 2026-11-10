//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that a default method body in an interface can call another requirement through `this`, dispatching to each conformer's implementation.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A default implementation inside an interface is checked against a stand-in
// for the still-unknown conforming type, so `this` there has to satisfy the
// interface's own requirements. Two conformers with different `base()` results
// are passed through a generic; the CHECKs assert each one's own
// implementation was reached from the shared default body.

//TEST:INTERPRET(filecheck=CHECK):

interface ICounter
{
    int base();
    int doubled() { return this.base() * 2; }
}

struct Five : ICounter { int base() { return 5; } }
struct Seven : ICounter { int base() { return 7; } }

int useIt<T : ICounter>(T v) { return v.doubled(); }

void main()
{
    Five f;
    Seven s;
    // CHECK: a=10
    printf("a=%d\n", useIt(f));
    // CHECK: b=14
    printf("b=%d\n", useIt(s));
}
