//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface may declare a constructor requirement (`__init(...)`) without a body; the conforming struct must provide a matching constructor.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a constructor requirement (`__init(int v)`) declared in an
// interface is satisfied by a matching `__init` on the conforming struct.
// InitStruct doubles the supplied value; CHECK asserts getValue() returns 10,
// confirming the constructor ran through the interface contract.

//TEST:INTERPRET(filecheck=CHECK):

interface IInitializable
{
    __init(int v);
    int getValue();
}

struct InitStruct : IInitializable
{
    int stored;

    __init(int v)
    {
        stored = v * 2;
    }

    int getValue() { return stored; }
}

void main()
{
    InitStruct s = InitStruct(5);
    //CHECK: value=10
    printf("value=%d\n", s.getValue());
}
