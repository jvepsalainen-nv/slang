//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An associated type requirement may be satisfied by a `typealias` declaration with the same name in the conforming struct.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `typealias` declaration satisfies an associatedtype requirement.
// IntContainer aliases ElementType = int; CHECK confirms getDefault() returns 0,
// which is only reachable if the compiler accepted the alias as the conformance witness.

//TEST:INTERPRET(filecheck=CHECK):

interface IContainer
{
    associatedtype ElementType;
    ElementType getDefault();
}

struct IntContainer : IContainer
{
    typealias ElementType = int;
    int getDefault() { return 0; }
}

void main()
{
    IntContainer c;
    //CHECK: default=0
    printf("default=%d\n", c.getDefault());
}
