//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface declares a set of member requirements; a conforming struct must provide compatible implementations of all required members.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies basic interface conformance: a struct satisfying a simple
// method requirement compiles and the method is callable at runtime.

//TEST:INTERPRET(filecheck=CHECK):

interface IValue
{
    int getValue();
}

struct Concrete : IValue
{
    int v;
    int getValue() { return v; }
}

void main()
{
    Concrete obj;
    obj.v = 42;
    //CHECK: result=42
    printf("result=%d\n", obj.getValue());
}
