//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface may declare a function call operator requirement (`operator()`); the conforming struct must provide a compatible implementation.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a call-operator (`operator()`) declared in an interface is
// satisfied by a matching implementation on the conforming struct. Multiplier
// implements `operator()(int x)` and is invoked as `m(5)`; CHECK asserts the
// result 15, proving the operator routes through the conformance correctly.

//TEST:INTERPRET(filecheck=CHECK):

interface ICallable
{
    int operator()(int x);
}

struct Multiplier : ICallable
{
    int factor;
    int operator()(int x) { return x * factor; }
}

void main()
{
    Multiplier m;
    m.factor = 3;
    //CHECK: result=15
    printf("result=%d\n", m(5));
}
